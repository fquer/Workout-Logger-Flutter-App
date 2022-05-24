import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomForm();
}

class _MyCustomForm extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController dateinput = TextEditingController();
    //final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: TextFormField(
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4af699)),
              ),
              hintStyle: TextStyle(color: Colors.white),
              icon: Icon(Icons.face, color: Colors.white),
              border: UnderlineInputBorder(),
              labelText: 'Name',
              labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: TextFormField(
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4af699)),
              ),
              icon: Icon(Icons.document_scanner, color: Colors.white),
              border: UnderlineInputBorder(),
              labelText: 'Surname',
              labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: TextField(
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            controller: dateinput, //editing controller of this TextField
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4af699)),
              ),
              icon: Icon(Icons.calendar_today,
                  color: Colors.white), //icon of text field
              labelText: "Birthdate",
              labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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
                  dateinput.text =
                      formattedDate; //set output date to TextField value.
                });
              } else {
                print("Tarih Seçilmedi !");
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              maxLength: 5,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff4af699)),
                ),
                icon: Icon(Icons.line_weight, color: Colors.white),
                border: UnderlineInputBorder(),
                labelText: 'Weight',
                labelStyle:
                    TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              keyboardType: TextInputType.number),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 64, 211, 133),
              ),
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      ],
    );
  }
}
