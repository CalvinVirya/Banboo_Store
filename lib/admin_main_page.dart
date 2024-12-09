import 'package:banboo_store/delete_page.dart';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/insert_page.dart';
import 'package:banboo_store/update_menu.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32D25),
        title: const Text(
          'ADMIN DASHBOARD',
          style: TextStyle(
            fontFamily: 'HG-Bold',
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              //WELCOME & SIGN OUT
              SizedBox(
                width: 380,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Text(
                      'Welcome Admin, "${AuthService.loggedUser!.username}"',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-reg',
                      ),
                    )),
                    ElevatedButton(
                      onPressed: () {
                        AuthService.loggedUser?.reset();
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFD32D25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Signout',
                        style: TextStyle(
                          fontFamily: 'HG-bold',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              //MENU
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //INSERT BUTTON
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 85,
                                height: 85,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InsertPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD32D25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/ui_component/insert.png',
                                    height: 37,
                                    width: 37,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Insert',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'HG-reg',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //UPDATE BUTTON
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 85,
                                height: 85,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateMenu(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD32D25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/ui_component/refresh.png',
                                    height: 37,
                                    width: 37,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'HG-reg',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //DELETE BUTTON
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 85,
                                height: 85,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeletePage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD32D25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/ui_component/trash-can.png',
                                    height: 37,
                                    width: 37,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'HG-reg',
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
