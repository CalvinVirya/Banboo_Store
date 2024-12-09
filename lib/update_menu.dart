import 'dart:convert';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:banboo_store/update_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateMenu extends StatefulWidget {
  const UpdateMenu({super.key});

  @override
  State<UpdateMenu> createState() => _UpdateMenuState();
}

class _UpdateMenuState extends State<UpdateMenu> {
  Future<List<Banboo>> fetchBanboos() async {
    var url = "http://10.0.2.2:3000/banboos/";
    var token = AuthService.loggedUser!.token;
    final response = await http.get(Uri.parse(url), headers: {'token': token});

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Banboo.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32D25),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          'Update Menu',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HG-Bold',
          ),
        ),
      ),
      body: FutureBuilder<List<Banboo>>(
        future: fetchBanboos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD32D25),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'There is no banboos data',
                style: TextStyle(
                  fontFamily: 'HG-reg',
                  color: Color(0xFFB0B0B0),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var banbooData = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.only(left: 5, right: 5),
                      title: Text(
                        banbooData.banboo_name,
                        style: const TextStyle(
                          fontFamily: 'HG-bold',
                          fontSize: 15,
                        ),
                      ),
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: banbooData.banboo_image.isNotEmpty
                            ? Image.memory(
                                base64Decode(banbooData.banboo_image),
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Text('Invalid image data');
                                },
                              )
                            : Container(), // Handle null or empty image
                      ),
                      subtitle: Text(
                        "ID: ${banbooData.banboo_id} Rank: ${banbooData.rank} Price: Rp${banbooData.price}",
                        style: const TextStyle(
                          fontFamily: 'HG-reg',
                          fontSize: 15,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePage(
                                banboo_id: snapshot.data![index].banboo_id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
