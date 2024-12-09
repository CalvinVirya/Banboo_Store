import 'dart:convert';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:banboo_store/payment_success.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final int banboo_id;
  final int price;
  final int quantity;
  final int totalPrice;

  const CheckoutPage({
    super.key,
    required this.banboo_id,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late final int id;
  late final int quantity;
  late final int total_price;
  late final int accountId;

  final _formKey = GlobalKey<FormState>();

  String? selectedItem;
  String? selectedItem2;

  List<String> entries = ['Regular', 'Sameday', 'Instant'];
  List<String> entries2 = [
    'Card',
    'Virtual Account',
    'Paylater',
    'Cash on Delivery'
  ];

  @override
  void initState() {
    super.initState();
    id = widget.banboo_id;
    quantity = widget.quantity;
    total_price = widget.totalPrice;
  }

  Future<Banboo> fetchBanbooById(int id) async {
    final url = "http://10.0.2.2:3000/banboos/$id";
    var token = AuthService.loggedUser!.token;
    final response = await http.get(
      Uri.parse(url),
      headers: {'token': token},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        return Banboo.fromJson(jsonResponse[0]);
      } else {
        throw Exception("No data found");
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  void _validateAndSubmitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccess(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32D25),
        title: const Text(
          'CHECKOUT PAGE',
          style: TextStyle(fontFamily: 'HG-Bold'),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Banboo>(
        future: fetchBanbooById(widget.banboo_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final banboo = snapshot.data!;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Please fill all the fields below',
                    style: TextStyle(
                      fontFamily: 'HG-bold',
                      fontSize: 15,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Shipping Address Field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Shipping Address',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFB0B0B0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD32D25)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your shipping address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Delivery Type Dropdown
                  DropdownButtonFormField(
                    value: selectedItem,
                    items: entries
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Delivery Type',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a delivery type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Payment Method Dropdown
                  DropdownButtonFormField(
                    value: selectedItem2,
                    items: entries2
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItem2 = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a payment method';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  //ORDER SUMMARY PADDING
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),

                        //TEXT
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontFamily: 'HG-bold',
                            fontSize: 15,
                            color: Color(0xFFB0B0B0),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        //ORDER SUMMARY
                        Container(
                          child: Column(
                            children: [
                              //CHARACTER
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Character:',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${banboo.banboo_name}',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              //PRICE
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price:',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Rp${banboo.price}',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              //QUANTITY
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity:',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${quantity}',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              //DELIVERY FEE
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Delivery Fee:',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Rp0',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              //TOTAL
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Rp${total_price}',
                                      style: TextStyle(
                                        fontFamily: 'HG-reg',
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _validateAndSubmitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFD32D25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'MAKE ORDER',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HG-bold',
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
