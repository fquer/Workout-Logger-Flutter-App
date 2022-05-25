import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<MyCustomForm> createState() => _MyCustomForm();
}

class _MyCustomForm extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Kullanicilar')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((element) {
          print("AAAAA " + element.id);
        });
      }
    });
    TextEditingController dateinput = TextEditingController();
    final name_controller = TextEditingController();
    final surname_controller = TextEditingController();
    final weight_controller = TextEditingController();
    final dialog_name_controller = TextEditingController();
    final dialog_surname_controller = TextEditingController();
    final dialog_weight_controller = TextEditingController();
    TextEditingController dialog_dateinput = TextEditingController();

    CollectionReference edit_weight = FirebaseFirestore.instance
        .collection('Kullanicilar')
        .doc(widget.id)
        .collection("Kilo");

    return Scaffold(
        backgroundColor: Color(0xff2c274c),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kullanicilar")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data != null) {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  if (snap.id == widget.id) {
                    name_controller.text = snap["KullaniciAd"];
                    surname_controller.text = snap["KullaniciSoyad"];
                    weight_controller.text = "123";
                    dateinput.text = snap["KullaniciDogumTarih"];
                  }
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: name_controller,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.face, color: Colors.white),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 16),
                    child: TextFormField(
                      enabled: false,
                      controller: surname_controller,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.document_scanner, color: Colors.white),
                        labelText: 'Surname',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 16),
                    child: TextField(
                      enabled: false,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today,
                            color: Colors.white), //icon of text field
                        labelText: "Birthdate",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
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
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            dateinput.text = formattedDate;
                            print(dateinput.text);
                          });
                        } else {
                          print("Tarih Seçilmedi !");
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 16),
                    child: TextFormField(
                        enabled: false,
                        controller: weight_controller,
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        maxLength: 5,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.line_weight, color: Colors.white),
                          border: UnderlineInputBorder(),
                          labelText: 'Weight',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        keyboardType: TextInputType.number),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 64, 211, 133),
                        ),
                        onPressed: () async {
                          dialog_dateinput.text = dateinput.text;
                          dialog_name_controller.text = name_controller.text;
                          dialog_surname_controller.text =
                              surname_controller.text;
                          dialog_weight_controller.text =
                              weight_controller.text;

                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                  backgroundColor: Color(0xff2c274c),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 16),
                                            child: Text(
                                              "Edit your profile",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 16),
                                          child: TextFormField(
                                            controller: dialog_name_controller,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4af699)),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              icon: Icon(Icons.face,
                                                  color: Colors.white),
                                              border: UnderlineInputBorder(),
                                              labelText: 'Name',
                                              labelStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 16),
                                          child: TextFormField(
                                            controller:
                                                dialog_surname_controller,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4af699)),
                                              ),
                                              icon: Icon(Icons.document_scanner,
                                                  color: Colors.white),
                                              border: UnderlineInputBorder(),
                                              labelText: 'Surname',
                                              labelStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 16),
                                          child: TextField(
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255)),
                                            controller:
                                                dialog_dateinput, //editing controller of this TextField
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff4af699)),
                                              ),
                                              icon: Icon(Icons.calendar_today,
                                                  color: Colors
                                                      .white), //icon of text field
                                              labelText: "Birthdate",
                                              labelStyle: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            readOnly:
                                                true, //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(
                                                          1900), //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime.now());

                                              if (pickedDate != null) {
                                                String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(pickedDate);

                                                setState(() {
                                                  dialog_dateinput.text =
                                                      formattedDate;
                                                  print(dateinput.text);
                                                });
                                              } else {
                                                print("Tarih Seçilmedi !");
                                              }
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 16),
                                          child: TextFormField(
                                              controller:
                                                  dialog_weight_controller,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                              maxLength: 5,
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
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
                                              keyboardType:
                                                  TextInputType.number),
                                        ),
                                        FloatingActionButton.extended(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Kullanicilar')
                                                .doc(widget.id)
                                                .update({
                                              'KullaniciAd':
                                                  dialog_name_controller.text,
                                              'KullaniciSoyad':
                                                  dialog_surname_controller
                                                      .text,
                                              'KullaniciDogumTarih':
                                                  dialog_dateinput.text,
                                            }).then((value) =>
                                                    print('Calisma eklendi.'));
                                            await edit_weight.add({
                                              'KiloDeger':
                                                  dialog_weight_controller.text,
                                              'KiloTarih':
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(DateTime.now()),
                                            }).then((value) =>
                                                print('kilo eklendi.'));
                                            print("Saved");
                                            Navigator.pop(context);
                                          },
                                          label: Text("Save",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          icon: Icon(
                                            Icons.add_task_sharp,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Color(0xff4af699),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  )));
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}
