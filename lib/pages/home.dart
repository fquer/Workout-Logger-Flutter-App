import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workoutlogger/pages/araskargo.dart';
import 'package:workoutlogger/pages/deneme2.dart';
import 'package:workoutlogger/pages/login_screen.dart';
import 'package:workoutlogger/pages/my_exercise.dart';
import 'package:workoutlogger/pages/preferences.dart';
import 'package:workoutlogger/pages/line_chart.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Home> createState() => _Home();
}

final growableList = <String>[];

class _Home extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MyExercise(
        id: widget.id,
      ),
      LineChartEx(),
      MyCustomForm(
        id: widget.id,
      )
    ];

    return Scaffold(
      backgroundColor: Color(0xff2c274c),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Workout Logger'),
        backgroundColor: Color.fromARGB(255, 29, 26, 51),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(
                            title: "Log In",
                          )));
                },
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff2c274c),
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet_outlined),
            label: 'Logger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility),
            label: 'Preferences',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff4af699),
        onTap: _onItemTapped,
      ),
    );
  }
}
