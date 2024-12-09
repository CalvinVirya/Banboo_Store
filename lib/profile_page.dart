import 'package:banboo_store/helper/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          // Mengembalikan false untuk mencegah aksi kembali
          return false;
        },
        child: Column(
          children: [
            //BLOK ATAS
            Container(
              color: Color(0xFFD32D25),
              height: 147,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //APPBAR APPBARAN
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Row(
                      children: [
                        //PRIFLE PICT
                        SizedBox(
                          width: 63,
                          height: 63,
                          child: Image.asset(
                            'assets/ui_component/profile-user.png',
                          ),
                        ),

                        SizedBox(
                          width: 8,
                        ),

                        //NAMA USER
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AuthService.loggedUser!.fullname}',
                                // "tes",
                                style: TextStyle(
                                  fontFamily: 'HG-bold',
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                // "tes",
                                '@${AuthService.loggedUser!.username}',
                                style: TextStyle(
                                  fontFamily: 'HG-reg',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
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

            //BODY
            SizedBox(
              height: 20,
            ),

            //PEMBATAS
            Container(
              height: 4,
              color: const Color.fromARGB(255, 237, 237, 237),
            ),

            //ABOUT
            Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/aboutpage');
                    },
                    icon: Icon(Icons.info_outline),
                    color: Color(0xFFB0B0B0),
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'HG-reg',
                      fontSize: 15,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                ],
              ),
            ),

            //PEMBATAS
            Container(
              height: 4,
              color: const Color.fromARGB(255, 237, 237, 237),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    AuthService.loggedUser?.reset();
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFFD32D25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: Color(0xFFD32D25),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Signout',
                    style: TextStyle(
                      fontFamily: 'HG-bold',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
