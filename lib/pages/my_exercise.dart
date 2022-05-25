import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workoutlogger/widgets/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyExercise extends StatefulWidget {
  const MyExercise({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<MyExercise> createState() => _MyExerciseState();
}

class _MyExerciseState extends State<MyExercise> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String dropdownValue = 'OHP';
  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final setController = TextEditingController();
    final tekrarController = TextEditingController();
    final kiloController = TextEditingController();
    CollectionReference calisma = FirebaseFirestore.instance
        .collection('Kullanicilar')
        .doc(widget.id)
        .collection("Calisma");
    int _index = 0;

    return Scaffold(
        backgroundColor: Color(0xff2c274c),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("Hareketler").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              late List<String> workoutItems = [];
              late List<String> workoutIDs = [];
              if (snapshot.data != null) {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  workoutItems.add(snap["HareketIsim"]);
                  workoutIDs.add(snap.id);
                }
              }
              return Column(
                children: <Widget>[
                  TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime(1999),
                    lastDay: DateTime(2030),
                    calendarFormat: format,
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Colors.white),
                        weekdayStyle: TextStyle(color: Colors.white)),
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    daysOfWeekVisible: true,
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                      print(focusedDay);
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    eventLoader: _getEventsfromDay,
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white),
                      isTodayHighlighted: true,

                      selectedDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 55, 179, 112),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      //defaultTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                          color: Colors.pinkAccent, shape: BoxShape.circle),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false),
                  ),
                  ..._getEventsfromDay(selectedDay).map(
                    (Event event) => ListTile(
                      title: Text(event.title),
                    ),
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Color.fromARGB(255, 55, 179, 112),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              scrollable: true,
                              backgroundColor: Color(0xff2c274c),
                              title: Text("Add Exercise"),
                              titleTextStyle: TextStyle(color: Colors.white),
                              content: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            Color.fromARGB(255, 35, 31, 61),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Select exercise :",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 20.0,
                                          ),
                                          DropdownButton<String>(
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_downward,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue = newValue!;
                                                _index = workoutItems
                                                    .indexOf(dropdownValue);
                                              });
                                            },
                                            items: workoutItems
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                          controller: setController,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          maxLength: 5,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff4af699)),
                                            ),
                                            icon: Icon(Icons.line_weight,
                                                color: Colors.white),
                                            border: UnderlineInputBorder(),
                                            labelText: 'Sets',
                                            labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
                                          keyboardType: TextInputType.number),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                          controller: tekrarController,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          maxLength: 5,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff4af699)),
                                            ),
                                            icon: Icon(Icons.line_weight,
                                                color: Colors.white),
                                            border: UnderlineInputBorder(),
                                            labelText: 'Reps',
                                            labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
                                          keyboardType: TextInputType.number),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: TextFormField(
                                          controller: kiloController,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                          maxLength: 5,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff4af699)),
                                            ),
                                            icon: Icon(Icons.line_weight,
                                                color: Colors.white),
                                            border: UnderlineInputBorder(),
                                            labelText: 'Weight',
                                            labelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                          ),
                                          keyboardType: TextInputType.number),
                                    ),
                                  ],
                                );
                              }),
                              actions: [
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("Ok"),
                                  onPressed: () async {
                                    if (dropdownValue.isEmpty) {
                                    } else {
                                      await calisma.add({
                                        'HareketID': workoutIDs[_index],
                                        'HareketIsim': dropdownValue,
                                        'CalismaSet': setController.text,
                                        'CalismaTekrar': tekrarController.text,
                                        'CalismaAgirlik': kiloController.text,
                                        'CalismaTarih': DateTime.now(),
                                      }).then(
                                          (value) => print('Calisma eklendi.'));

                                      if (selectedEvents[selectedDay] != null) {
                                        selectedEvents[selectedDay]?.add(
                                          Event(title: dropdownValue),
                                        );
                                      } else {
                                        selectedEvents[selectedDay] = [
                                          Event(title: dropdownValue)
                                        ];
                                      }
                                      dropdownValue = workoutItems[0];
                                    }
                                    Navigator.pop(context);
                                    setState(() {});
                                    return;
                                  },
                                ),
                              ],
                            )),
                    label: Text("Add Exercise"),
                    icon: Icon(Icons.add_task_sharp),
                  )
                ],
              );
            }));
  }
}
