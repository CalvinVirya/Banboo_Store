import 'dart:convert';
import 'package:banboo_store/admin_main_page.dart';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
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

  void _deleteOnPressed(int index, AsyncSnapshot snapshot) async {
    var url_delete =
        "http://10.0.2.2:3000/banboos/delete/${snapshot.data![index].banboo_id}";
    final delete = await http.delete(
      Uri.parse(url_delete),
      headers: {"Content-Type": "application/json"},
    );
    print(delete.statusCode);
    if (delete.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMainPage(),
        ),
      );
    }
  }

  void _confirmation(BuildContext context, int index, AsyncSnapshot snapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: Text(
            'Delete this item?',
            style: TextStyle(
              fontFamily: 'HG-medium',
              fontSize: 25,
            ),
          ),
          content: Text(
            'This action cannot be undone!',
            style: TextStyle(
              fontFamily: 'HG-medium',
              fontSize: 12,
              color: Color(0xFFB0B0B0),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteOnPressed(index, snapshot);
                Navigator.of(context).pop(); // Menutup dialog setelah delete
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFD32D25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32D25),
        title: const Text(
          'Delete',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HG-Bold',
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
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
                          _confirmation(context, index, snapshot);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xFFD32D25),
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
