import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutlogger/pages/app_styles.dart';

class LineChartEx extends StatefulWidget {
  const LineChartEx({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<LineChartEx> createState() => LineChartExState();
}

class LineChartExState extends State<LineChartEx> {
  TextEditingController firstdate = TextEditingController();
  TextEditingController endingdate = TextEditingController();
  String dropdownValue = 'Weight';

  @override
  void initState() {
    super.initState();
    firstdate = new TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 30))));
    endingdate = new TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  String bottomGrap(int gap, int width) {
    if (DateTime.parse(endingdate.text).month -
            DateTime.parse(firstdate.text).month ==
        0) {
      return ((((DateTime.parse(endingdate.text).day) -
                  (DateTime.parse(firstdate.text).day))) *
              gap /
              width)
          .round()
          .toString();
    }
    return (((DateTime.parse(endingdate.text).month -
                    DateTime.parse(firstdate.text).month) *
                ((DateTime.parse(endingdate.text).day) +
                    (30 - DateTime.parse(firstdate.text).day))) *
            gap /
            width)
        .round()
        .toString();
  }

  List<LineChartBarData> linesBarData(List<double> weight_items) {
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: weight_items.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble() + 1, e.value);
      }).toList(),
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [
      lineChartBarData2,
    ];
  }

  LineChartData sampleData1(List<double> weight_items) {
    double yMax = 0, yMin = weight_items[0];
    for (int i = 0; i < weight_items.length; i++) {
      if (yMax < weight_items[i]) {
        yMax = weight_items[i];
      }
      if (yMin > weight_items[i]) {
        yMin = weight_items[i];
      }
    }
    return LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,
          ),
          touchCallback: (LineTouchResponse touchResponse) {},
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: const TextStyle(
              color: Color(0xff72719b),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            margin: 10,
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '1';
                case 2:
                  return '2';
                case 3:
                  return '3';
                case 4:
                  return '4';
                case 5:
                  return '5';
                case 10:
                  return '10';
                case 20:
                  return '20';
                case 30:
                  return '30';
                case 40:
                  return '40';
                case 50:
                  return '50';
                case 60:
                  return '60';
                case 70:
                  return '70';
                case 80:
                  return '80';
                case 90:
                  return '90';
                case 100:
                  return '100';
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: const TextStyle(
              color: Color(0xff75729e),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 10:
                  return '10';
                case 20:
                  return '20';
                case 30:
                  return '30';
                case 40:
                  return '40';
                case 50:
                  return '50';
                case 60:
                  return '60';
                case 70:
                  return '70';
                case 80:
                  return '80';
                case 90:
                  return '90';
                case 100:
                  return '100';
              }
              return '';
            },
            margin: 8,
            reservedSize: 25,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Colors.red,
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        minX: 1,
        maxX: weight_items.length.toDouble(),
        maxY: yMax,
        minY: yMin - 2,
        lineBarsData: linesBarData(weight_items));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Hareketler").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          late List<String> currencyItems = ['Weight'];
          if (snapshot.data != null) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data!.docs[i];
              currencyItems.add(snap["HareketIsim"]);
            }
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kullanicilar")
                .doc(widget.id)
                .collection("Kilo")
                .where('KiloTarih',
                    isGreaterThan: DateTime.parse(firstdate.text))
                .where('KiloTarih',
                    isLessThan: DateTime.parse(endingdate.text)
                        .add(const Duration(days: 1)))
                .orderBy("KiloTarih")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              late List<double> weight_items = [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                weight_items = [0];
              }

              if (snapshot.data != null) {
                weight_items = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];

                  weight_items.add(double.parse(snap["KiloDeger"]));
                }
              }
              return Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color.fromARGB(255, 35, 31, 61),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 17,
                              ),
                              elevation: 16,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: currencyItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          controller:
                              firstdate, //editing controller of this TextField
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff4af699)),
                            ),
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                            labelText: "Başlangıç",
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 1)),
                                firstDate: DateTime(
                                    1900), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime.now()
                                    .subtract(const Duration(days: 1)));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              print(DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()));
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                firstdate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Tarih Seçilmedi !");
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          controller:
                              endingdate, //editing controller of this TextField
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff4af699)),
                            ),
                            suffixIconColor: Color.fromARGB(255, 255, 255, 255),
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                            labelText: "Bitiş",
                            labelStyle:
                                TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(
                                    1900), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime.now());

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                endingdate.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Tarih Seçilmedi !");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 420,
                    //margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      //borderRadius: const BorderRadius.all(Radius.circular(18)),
                      color: Color(0xff2c274c),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          dropdownValue,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: LineChart(sampleData1(weight_items)),
                          ),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      firstdate.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 130, 125, 170),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 205,
                    ),
                    Text(
                      endingdate.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 130, 125, 170),
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ]);
            },
          );
        });
  }
}
