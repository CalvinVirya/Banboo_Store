import 'package:banboo_store/about.dart';
import 'package:banboo_store/login_page.dart';
// import 'package:banboo_store/payment_success.dart';
import 'package:banboo_store/signup_page.dart';
// import 'package:banboo_store/user_main_page.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/aboutpage': (context) => const AboutPage()
        // '/usermainpage': (context) => const UserMainPage(),
        // '/paymentsuccess': (context) => PaymentSuccess(),
      },
    );
  }
}
