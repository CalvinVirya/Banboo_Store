import 'dart:async';
import 'package:banboo_store/user_main_page.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});
  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserMainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //IMAGE
            Image.asset(
              'assets/ui_component/checklist.png',
              height: 100,
              width: 100,
            ),

            //TULISAN
            Text(
              'Payment Success',
              style: TextStyle(
                fontFamily: 'HG-Bold',
                fontSize: 30,
              ),
            ),

            SizedBox(
              height: 7,
            ),

            Text(
              'Thankyou for shopping with us',
              style: TextStyle(
                fontFamily: 'HG-Bold',
                fontSize: 15,
                color: const Color(0xFFB0B0B0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
