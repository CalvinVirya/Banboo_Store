import 'dart:convert';

import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:banboo_store/product_page.dart';
import 'package:banboo_store/user_main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var prefixController = TextEditingController();

  Future<List<Banboo>> fetchBanboosByPrefix() async {
    var prefix = prefixController.text;
    if (prefix.contains('Rank')) {
      var url = "http://10.0.2.2:3000/banboos/search-by-rank/$prefix";
      var token = AuthService.loggedUser!.token;
      final response =
          await http.get(Uri.parse(url), headers: {'token': token});
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Banboo.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      var url = "http://10.0.2.2:3000/banboos/search/$prefix";
      var token = AuthService.loggedUser!.token;
      final response =
          await http.get(Uri.parse(url), headers: {'token': token});
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Banboo.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFD32D25),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserMainPage(),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SEARCH BAR
            Container(
              width: 270,
              height: 37,
              child: TextField(
                controller: prefixController,
                decoration: const InputDecoration(
                  labelText: 'Search "Banboo"',
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.only(left: 12),
                  labelStyle: TextStyle(
                    fontFamily: 'HG-bold',
                    color: Colors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'HG-reg',
                ),
              ),
            ),
            // ICON
            Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    // OPSI 1
                    ElevatedButton(
                      onPressed: () {
                        prefixController.text = 'A Rank';
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFD32D25),
                      ),
                      child: Text(
                        'A Rank',
                        style: TextStyle(
                          fontFamily: 'HG-bold',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // OPSI 2
                    ElevatedButton(
                      onPressed: () {
                        prefixController.text = 'S Rank';
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFFD32D25),
                      ),
                      child: Text(
                        'S Rank',
                        style: TextStyle(
                          fontFamily: 'HG-bold',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 129),
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              child: FutureBuilder<List<Banboo>>(
                future: fetchBanboosByPrefix(),
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
                        'Try searching first',
                        style: TextStyle(
                          fontFamily: 'HG-reg',
                          color: Color(0xFFB0B0B0),
                        ),
                      ),
                    );
                  } else {
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var banbooData = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  banboo_id: banbooData.banboo_id,
                                  price: banbooData.price,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                banbooData.banboo_image.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(banbooData.banboo_image),
                                        width: 67,
                                        height: 73,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error,
                                              size: 50);
                                        },
                                      )
                                    : const Icon(Icons.image,
                                        size: 50, color: Colors.blue),
                                const SizedBox(height: 8),
                                Text(
                                  banbooData.banboo_name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'HG-medium',
                                  ),
                                ),
                                Text(
                                  'Rp${banbooData.price.toString()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFD32D25),
                                    fontFamily: 'HG-bold',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
