import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:workoutlogger/pages/home.dart';
import 'package:workoutlogger/pages/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadUserEmailPassword();
    _handleRemeberme();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  String id = '';
  bool control = true;
  String errorMsg = '';
  String? deneme = '';
  bool _isChecked = false;
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deneme = null;
    return Scaffold(
      backgroundColor: Color(0xff2c274c),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
            ),
            const SizedBox(
              height: 60,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    controller: email_controller,
                    validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xff4af699),
                          width: 4.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    controller: password_controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Minimum password length is 6.';
                      } else if (control == false) {
                        return "Inc";
                      }
                      return null;
                    },
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xff4af699),
                          width: 4.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: CheckboxListTile(
                      title: const Text(
                        "Remember me",
                        style: TextStyle(color: Colors.white),
                      ),
                      checkColor: Color(0xff4af699),
                      selectedTileColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      value: rememberValue,
                      activeColor: Color(0xff2c274c),
                      onChanged: (newValue) {
                        setState(() {
                          print(newValue);
                          rememberValue = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _handleRemeberme();
                        FirebaseFirestore.instance.collection('Kullanicilar').where('KullaniciEmail', isEqualTo: email_controller.text).where('KullaniciSifre', isEqualTo: password_controller.text).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            querySnapshot.docs.forEach((element) {
                              print(element.id);
                              id = element.id.toString();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        id: id,
                                      )),
                            );
                          } else {
                            setState(() {
                              errorMsg = "Incorrect email or password.";
                            });
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 64, 211, 133),
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not registered yet?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage(title: 'Register UI'), maintainState: false),
                          );
                        },
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                            color: Color(0xff4af699),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleRemeberme() {
    print("Handle Rember Me");
    _isChecked = rememberValue;
    print(rememberValue);
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", rememberValue);
        prefs.setString('email', email_controller.text);
        prefs.setString('password', password_controller.text);
      },
    );
    setState(() {
      _isChecked = rememberValue;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      rememberValue = true;
      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        email_controller.text = _email ?? "";
        password_controller.text = _password ?? "";
      }
    } catch (e) {
      print(e);
      print('hata');
    }
  }
}
