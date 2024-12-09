import 'dart:convert';

import 'package:banboo_store/admin_main_page.dart';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/user.dart';
import 'package:banboo_store/user_main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void signInGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // Performs Sign In, will return user account's info
    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    // Account will be null if user cancelled the sign in process
    if (account != null) {
      print('Email user: ${account.email}');
      print('Nama user: ${account.displayName}');
      // accountEmailController.text = account.email;
      // AuthService.loggedUser?.email = account.email;
      // AuthService.loggedUser?.fullname = account.displayName!;

      AuthService.loggedUser = User(
        id: 0,
        fullname: account.displayName!,
        username: '',
        email: account.email,
        token: '',
      );

      _loginGoogle(context);
    }
  }

  void signOutGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }

  var accountEmailController = TextEditingController();
  var accountPasswordController = TextEditingController();

  void _loginGoogle(BuildContext context) async {
    var validate =
        "http://10.0.2.2:3000/accounts/get_email/google/${AuthService.loggedUser?.email}";
    var googleLogin = await http.get(Uri.parse(validate));
    if (googleLogin.statusCode == 200 && googleLogin.body != '[]') {
      print('tess');
      var googleLoginData = json.decode(googleLogin.body);
      accountEmailController.text = googleLoginData[0]['email'];
      accountPasswordController.text = googleLoginData[0]['password'];
      _loginOnPressed(context);
    } else {
      Navigator.pushNamed(context, '/signup');
    }
  }

  void _loginOnPressed(BuildContext context) async {
    var validate = "http://10.0.2.2:3000/accounts/login";
    var login = await http.post(Uri.parse(validate), body: {
      'email': accountEmailController.text,
      'password': accountPasswordController.text
    });
    if (login.statusCode == 200) {
      var loginData = json.decode(login.body);
      AuthService.loggedUser = User.fromJson(loginData);
      print(loginData);
      if (loginData['role'] == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminMainPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserMainPage(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wrong email or password',
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
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //GAMBAR LOGIN
            SizedBox(
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
                      'assets/ui_component/login_char.png',
                      width: 309,
                      height: 175,
                    ),
                  )
                ],
              ),
            ),

            //FORM
            SizedBox(
              width: 380,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: accountEmailController,
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

                    const SizedBox(height: 5),

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

                    const SizedBox(height: 5),

                    //BUTTON LOGIN
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _loginOnPressed(context);
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
                      child: const Text('Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'HG-bold',
                          )),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),

            //OR SIGN UP WITH
            const SizedBox(
              width: 380,
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB0B0B0),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or login using',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontFamily: 'HG-bold',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB0B0B0),
                      thickness: 1,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 5),

            //LOGIN WITH
            SizedBox(
              width: 380,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        //GOOGLE
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              signInGoogle();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  width: 1, color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/ui_component/google.png',
                                  height: 24.0,
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                const Text(
                                  'Login with Google',
                                  style: TextStyle(
                                    fontFamily: 'HG-bold',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 5),

            Spacer(),

            //SIGN UP
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    // AuthService.loggedUser?.reset();
                    Navigator.pushNamed(
                      context,
                      '/signup',
                    );
                  },
                  child: const Text(
                    'Don’t have an account? Sign up',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontFamily: 'HG-bold',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
