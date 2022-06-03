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
    print(DateTime.now().runtimeType);
    TextEditingController dateinput = TextEditingController();
    final name_controller = TextEditingController();
    final surname_controller = TextEditingController();
    final weight_controller = TextEditingController();
    final dialog_name_controller = TextEditingController();
    final dialog_surname_controller = TextEditingController();
    final dialog_weight_controller = TextEditingController();
    TextEditingController dialog_dateinput = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    DateTime now;
    String weigth_id = '';
    bool founded = false;

    CollectionReference add_weight = FirebaseFirestore.instance
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

                    dateinput.text = snap["KullaniciDogumTarih"];

                    FirebaseFirestore.instance
                        .collection('Kullanicilar')
                        .doc(widget.id)
                        .collection('Kilo')
                        .orderBy("KiloTarih")
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      print(querySnapshot.docs.isEmpty);
                      if (querySnapshot.docs.isNotEmpty) {
                        print(querySnapshot.docs.last['KiloDeger']);
                        weight_controller.text =
                            querySnapshot.docs.last['KiloDeger'];
                        weigth_id = querySnapshot.docs.last.id;
                      }
                    });
                  }
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name_controller.text),
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
                                      child: Form(
                                    key: _formKey,
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
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Name is can't be empty";
                                              }
                                              return null;
                                            },
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
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Surname is can't be empty";
                                              }
                                              return null;
                                            },
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
                                                });
                                              } else {
                                                print("Tarih Seçilmedi !");
                                              }
                                            },
                                          ),
                                        ),
                                        FloatingActionButton.extended(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
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
                                              }).then((value) => print(
                                                      'Kullanici guncellendi.'));

                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            }
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
                                  ))));
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: Row(
                      children: [
                        Container(
                          width: 300,
                          height: 100,
                          child: TextFormField(
                              enabled: false,
                              controller: weight_controller,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              maxLength: 5,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.line_weight,
                                    color: Colors.white),
                                border: UnderlineInputBorder(),
                                labelText: 'Weight',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                              keyboardType: TextInputType.number),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, left: 10),
                          child: IconButton(
                            onPressed: () async {
                              dialog_dateinput.text = dateinput.text;
                              dialog_name_controller.text =
                                  name_controller.text;
                              dialog_surname_controller.text =
                                  surname_controller.text;
                              dialog_weight_controller.text =
                                  weight_controller.text;

                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      backgroundColor: Color(0xff2c274c),
                                      child: SingleChildScrollView(
                                          child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25,
                                                        vertical: 16),
                                                child: Text(
                                                  "Update your weight",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 16),
                                              child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Weight is can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      dialog_weight_controller,
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
                                                  maxLength: 5,
                                                  decoration:
                                                      const InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(
                                                              0xff4af699)),
                                                    ),
                                                    icon: Icon(
                                                        Icons.line_weight,
                                                        color: Colors.white),
                                                    border:
                                                        UnderlineInputBorder(),
                                                    labelText: 'Weight',
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number),
                                            ),
                                            FloatingActionButton.extended(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'Kullanicilar')
                                                      .doc(widget.id)
                                                      .collection('Kilo')
                                                      .get()
                                                      .then((QuerySnapshot
                                                          querySnapshot) {
                                                    if (querySnapshot
                                                        .docs.isNotEmpty) {
                                                      querySnapshot.docs
                                                          .forEach((element) {
                                                        now = DateTime.now();
                                                        DateTime db_cal =
                                                            element['KiloTarih']
                                                                .toDate();

                                                        print("asd");
                                                        print(DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(now));
                                                        print("asd");
                                                        print(DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(db_cal));
                                                        if (DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(now) ==
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    db_cal)) {
                                                          founded = true;
                                                          print("girdi");
                                                        }
                                                      });

                                                      if (founded == true) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Kullanicilar')
                                                            .doc(widget.id)
                                                            .collection('Kilo')
                                                            .doc(weigth_id)
                                                            .update({
                                                          'KiloDeger':
                                                              dialog_weight_controller
                                                                  .text,
                                                        }).then((value) => print(
                                                                'Kilo guncellendi. Ayni tarihten bulundu.'));
                                                        founded = false;
                                                      } else {
                                                        add_weight.add({
                                                          'KiloDeger':
                                                              dialog_weight_controller
                                                                  .text,
                                                          'KiloTarih':
                                                              DateTime.now(),
                                                        }).then((value) => print(
                                                            'kilo eklendi. Ayni tarihten bulunamadi.'));
                                                      }
                                                    } else {
                                                      add_weight.add({
                                                        'KiloDeger':
                                                            dialog_weight_controller
                                                                .text,
                                                        'KiloTarih':
                                                            DateTime.now(),
                                                      }).then((value) => print(
                                                          'Kilo eklendi. Sifir hesap kullanici.'));
                                                    }
                                                  });
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              },
                                              label: Text("Update",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              icon: Icon(
                                                Icons.add_task_sharp,
                                                color: Colors.white,
                                              ),
                                              backgroundColor:
                                                  Color(0xff4af699),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ))));
                            },
                            icon: Icon(Icons.edit, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
