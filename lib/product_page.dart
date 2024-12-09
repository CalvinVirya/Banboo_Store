import 'dart:convert';
import 'package:banboo_store/checkout_page.dart';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  final int banboo_id;
  final int price;
  const ProductPage({super.key, required this.banboo_id, required this.price});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final int id;
  late final int accountId;
  late int _totalPrice;
  late int banbooPrice;

  @override
  void initState() {
    super.initState();
    id = widget.banboo_id;
    _totalPrice = widget.price * _quantity;
  }

  Future<Banboo> fetchBanbooById(int id) async {
    final url = "http://10.0.2.2:3000/banboos/$id";
    var token = AuthService.loggedUser!.token;
    final response = await http.get(
      Uri.parse(url),
      headers: {'token': token},
    );
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      banbooPrice = jsonResponse[0]['price'];
      if (jsonResponse.isNotEmpty) {
        return Banboo.fromJson(jsonResponse[0]);
      } else {
        throw Exception("No data found");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  int _quantity = 1;
  late int price = banbooPrice;
  late int totalPrice = price * _quantity;
  late int quantity = 1;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = widget.price * _quantity;
      totalPrice = _totalPrice;
      quantity = _quantity;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _totalPrice = widget.price * _quantity;
        totalPrice = _totalPrice;
        quantity = _quantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFD32D25),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //ICON SHARE
            Container(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Share feature coming soon"),
                      duration: Duration(
                        seconds: 2,
                      ),
                    ),
                  );
                },
                icon: Image.asset('assets/ui_component/share.png'),
              ),
            ),

            SizedBox(
              width: 10,
            ),

            //ICON CART
            Container(
              width: 45,
              height: 45,
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cart feature coming soon"),
                      duration: Duration(
                        seconds: 2,
                      ),
                    ),
                  );
                },
                icon: Image.asset('assets/ui_component/market-white.png'),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Banboo>(
          future: fetchBanbooById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final banboo = snapshot.data!;
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //GAMBAR CHARACTER
                    Container(
                      color: const Color.fromARGB(255, 237, 237, 237),
                      width: double.infinity,
                      height: 270,
                      child: banboo.banboo_image.isNotEmpty
                          ? Image.memory(
                              base64Decode(banboo.banboo_image),
                              width: 67,
                              height: 73,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 50);
                              },
                            )
                          : const Icon(Icons.image,
                              size: 50, color: Colors.blue),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //JUDUL DESKRIPSI HARGA
                    Container(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //CHARACTER NAME
                                  Text(
                                    '${banboo.banboo_name}',
                                    style: TextStyle(
                                      fontFamily: 'HG-medium',
                                      fontSize: 30,
                                    ),
                                  ),

                                  Text(
                                    '${banboo.rank}',
                                    style: TextStyle(
                                      fontFamily: 'HG-bold',
                                      fontSize: 20,
                                      color: Color(0xFFD32D25),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 5,
                              ),

                              //DESCRIPTION
                              Text(
                                '${banboo.banboo_desc}',
                                style: TextStyle(
                                  fontFamily: 'HG-light',
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ),

                              //PRICE
                              Text(
                                'Rp${banboo.price}',
                                style: TextStyle(
                                  fontFamily: 'HG-bold',
                                  fontSize: 30,
                                  color: Color(0xFFD32D25),
                                ),
                              ),

                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //PEMBATAS
                    Container(
                      height: 4,
                      color: const Color.fromARGB(255, 237, 237, 237),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //CHARACTER DETAIL:
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Character Detail:',
                              style: TextStyle(
                                fontFamily: 'HG-light',
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //ID
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/element.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Element:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.element_name}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //HP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/water-drop.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'HP:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.hp}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //ATK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/raise-hand.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'ATK:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.atk}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //DEF
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/shield-1.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'DEF:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.def}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //IMPACT
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/meteorite.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Impact:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.impact}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //CRIT RATE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/explosion.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'CRIT Rate:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.crit_rate}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //CRIT DMG
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/explosion.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'CRIT DMG:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.crit_dmg}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //PEN RATIO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/shield.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'PEN Ratio:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.pen_ratio}'),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //ANOMALY MASTERY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            'assets/ui_component/anomaly.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Anomaly Mastery:',
                                        style: TextStyle(
                                          fontFamily: 'HG-reg',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text('${banboo.anomaly_mastery}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //PEMBATAS
                    Container(
                      height: 4,
                      color: const Color.fromARGB(255, 237, 237, 237),
                    ),

                    SizedBox(
                      height: 6,
                    ),

                    //BUY CHARACTER
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buy Character',
                              style: TextStyle(
                                fontFamily: 'HG-light',
                                fontSize: 15,
                              ),
                            ),

                            //QUANTITIY AND TOTAL
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Quantity',
                                          style: TextStyle(
                                            fontFamily: 'HG-medium',
                                            fontSize: 15,
                                            color: Color(0xFFB0B0B0),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _decreaseQuantity();
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            Text(
                                              '$_quantity',
                                              style: TextStyle(
                                                fontFamily: 'HG-medium',
                                                fontSize: 15,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: _increaseQuantity,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                            fontFamily: 'HG-medium',
                                            fontSize: 15,
                                            color: Color(0xFFB0B0B0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Rp${_totalPrice}',
                                          style: TextStyle(
                                            fontFamily: 'HG-medium',
                                            fontSize: 15,
                                          ),
                                        )
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

                    //PEMBATAS
                    Container(
                      height: 4,
                      color: const Color.fromARGB(255, 237, 237, 237),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //BUTTON BAWAH
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 95,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  color: Color(0xFFD32D25),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Cart feature coming soon"),
                                    duration: Duration(
                                      seconds: 2,
                                    ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/ui_component/market-red.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFD32D25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                      banboo_id: banboo.banboo_id, // ID produk
                                      price: banboo.price, // Harga produk
                                      quantity: quantity, // Jumlah barang
                                      totalPrice: totalPrice, // Total harga
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'BUY NOW',
                                style: TextStyle(
                                  fontFamily: 'HG-bold',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data found.'));
            }
          },
        ),
      ),
    );
  }
}
