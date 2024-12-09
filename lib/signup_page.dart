import 'dart:convert';

import 'package:banboo_store/helper/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var accountFullnameController = TextEditingController();
  var accountUsernameController = TextEditingController();
  var accountEmailController = TextEditingController();
  var accountPasswordController = TextEditingController();

  void signOutGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }

  @override
  void initState() {
    signOutGoogle();
    super.initState();
  }

  void _registerOnPressed(BuildContext context) async {
    var insert = "http://10.0.2.2:3000/accounts/insert";
    var validate =
        "http://10.0.2.2:3000/accounts/get_email/google/${accountEmailController.text}";
    var data = jsonEncode({
      "fullname": accountFullnameController.text,
      "username": accountUsernameController.text,
      "email": accountEmailController.text,
      "password": accountPasswordController.text,
      "role": 1,
    });

    var cek = await http.get(
      Uri.parse(validate),
      headers: {"Content-Type": "application/json"},
    );
    if (cek.statusCode == 200 && cek.body == '[]') {
      final register = await http.post(
        Uri.parse(insert),
        headers: {"Content-Type": "application/json"},
        body: data,
      );
      if (register.statusCode == 200) {
        // final registerData = json.decode(register.body);
        // final accountId = registerData[0]['id'];
        Navigator.pushNamed(context, '/login');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account already exist',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'HG-medium',
            ),
          ),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //GAMBAR LOGIN
          Container(
            width: 500,
            height: 225,
            child: Stack(
              children: [
                Positioned(
                    top: -130,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/ui_component/background.png',
                    )),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/ui_component/signup_char.png',
                    width: 309,
                    height: 175,
                  ),
                )
              ],
            ),
          ),

          //FORM
          Container(
            width: 380,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //FULLNAME INPUT
                  const Text(
                    'Fullname',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-medium',
                        color: Color(0xFFB0B0B0)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: accountFullnameController =
                        TextEditingController(
                            text: AuthService.loggedUser?.fullname),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD32D25),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(height: 1),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your fullname';
                      }
                      return null;
                    },
                  ),

                  //USERNAME INPUT
                  const Text(
                    'Username',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-medium',
                        color: Color(0xFFB0B0B0)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: accountUsernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD32D25),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(height: 1),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),

                  //EMAIL INPUT
                  const Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-medium',
                        color: Color(0xFFB0B0B0)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: accountEmailController = TextEditingController(
                        text: AuthService.loggedUser?.email),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD32D25),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(height: 1),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),

                  //PASSWORD INPUT
                  const Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-medium',
                        color: Color(0xFFB0B0B0)),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: accountPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFD32D25),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(height: 1),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  //BUTTON SIGNUP
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _registerOnPressed(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFD32D25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-bold',
                      ),
                    ),
                  ),
                  const SizedBox(height: 65),

                  //LOGIN
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          AuthService.loggedUser!.reset();
                          Navigator.pushNamed(
                            context,
                            '/login',
                          );
                        },
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontFamily: 'HG-bold',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
