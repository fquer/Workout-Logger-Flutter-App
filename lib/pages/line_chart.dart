import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutlogger/pages/app_styles.dart';

class LineChartEx extends StatefulWidget {
  const LineChartEx({Key? key}) : super(key: key);

  @override
  State<LineChartEx> createState() => LineChartExState();
}

String dropdownValue = 'Weight';
TextEditingController firstdate = TextEditingController();
TextEditingController endingdate = TextEditingController();

class LineChartExState extends State<LineChartEx> {
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
                              .map<DropdownMenuItem<String>>((String value) {
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                1900), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2030));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          print(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                            lastDate: DateTime(2030));

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
                    Text(
                      firstdate.text + ' - ' + endingdate.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 130, 125, 170),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
                        child: LineChart(sampleData1()),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ))
          ]);
        });
  }

  LineChartData sampleData1() {
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

              case 4:
                return '4';

              case 7:
                return '7';

              case 10:
                return '10';

              case 13:
                return '13';

              case 16:
                return '16';
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
              case 40:
                return '40';
              case 50:
                return '50';
              case 60:
                return '60';
              case 70:
                return '70';
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
      minX: 0,
      maxX: 16,
      maxY: 70,
      minY: 35,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 40),
        FlSpot(2, 42.5),
        FlSpot(3, 45),
        FlSpot(5, 50),
        FlSpot(7, 47.5),
        FlSpot(10, 62.5),
        FlSpot(12, 65),
        FlSpot(15, 70),
      ],
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
}
