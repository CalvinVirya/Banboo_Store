import 'dart:convert';
import 'dart:io';

import 'package:banboo_store/admin_main_page.dart';
import 'package:banboo_store/helper/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  var banbooNameController = TextEditingController();
  var banbooPriceController = TextEditingController();
  String? banbooRankController;
  var banbooLevelController = TextEditingController();
  var banbooHpController = TextEditingController();
  var banbooAtkController = TextEditingController();
  var banbooDefController = TextEditingController();
  var banbooImpactController = TextEditingController();
  var banbooCritRateController = TextEditingController();
  var banbooCritDmgController = TextEditingController();
  var banbooPenRatioController = TextEditingController();
  var banbooAMController = TextEditingController();
  var banbooElementIDController = TextEditingController();
  var banbooDescController = TextEditingController();
  Uint8List? banbooImageController;

  void _insertOnPressed(BuildContext context) async {
    var url = "http://10.0.2.2:3000/banboos/insert";
    var json = jsonEncode({
      "banboo_name": banbooNameController.text,
      "price": banbooPriceController.text,
      "rank": banbooRankController,
      "level": banbooLevelController.text,
      "hp": banbooHpController.text,
      "atk": banbooAtkController.text,
      "def": banbooDefController.text,
      "impact": banbooImpactController.text,
      "crit_rate": banbooCritRateController.text,
      "crit_dmg": banbooCritDmgController.text,
      "pen_ratio": banbooPenRatioController.text,
      "anomaly_mastery": banbooAMController.text,
      "element_id": banbooElementIDController.text,
      "banboo_desc": banbooDescController.text,
      "banboo_image": banbooImageController != null
          ? base64Encode(banbooImageController!)
          : null,
    });
    var token = AuthService.loggedUser!.token;

    var insert = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json', 'token': token},
      body: json,
    );

    if (insert.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Insert Successful',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'HG-medium',
            ),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminMainPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Insert Failed',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'HG-medium',
            ),
          ),
        ),
      );
    }
  }

  String? fileName;
  final _formKey = GlobalKey<FormState>();
  List<String> entries = ['S Rank', 'A Rank'];
  File? image;
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32D25),
        title: const Text(
          'Insert',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HG-Bold',
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // PRODUCT INPUT
                TextFormField(
                  controller: banbooNameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Character Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD32D25),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the character name';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 10,
                ),

                // PRICE INPUT
                TextFormField(
                  controller: banbooPriceController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Price',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD32D25),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // DROPDOWN RANK
                DropdownButtonFormField(
                  value: selectedItem,
                  items: entries
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                      banbooRankController = selectedItem;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Rank',
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD32D25),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a rank';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                //Input Level
                TextFormField(
                  controller: banbooLevelController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Level',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD32D25),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp('[0-9]'),
                    )
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the level';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                //TULISAN CHARACTER DETAIL
                const SizedBox(
                  width: 380,
                  child: Text(
                    'Character Details',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                ),

                //CHARACTER DETAIL
                Container(
                  child: Column(
                    children: [
                      // INPUT HP
                      Row(
                        children: [
                          const Text(
                            'HP: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooHpController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the HP';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT ATK
                      Row(
                        children: [
                          const Text(
                            'ATK: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooAtkController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the ATK';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT DEF
                      Row(
                        children: [
                          const Text(
                            'DEF: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooDefController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the DEF';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT IMPACT
                      Row(
                        children: [
                          const Text(
                            'Impact: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooImpactController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Impact';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT CRIT RATE
                      Row(
                        children: [
                          const Text(
                            'CRIT Rate: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooCritRateController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the CRIT Rate';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT CRIT DMG
                      Row(
                        children: [
                          const Text(
                            'CRIT DMG: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooCritDmgController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the CRIT DMG';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT PEN RATIO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PEN Ratio: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooPenRatioController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the PEN Ratio';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT ANOMALY MASTERY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Anomaly Mastery: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooAMController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Anomaly Mastery';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // INPUT ELEMENT ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Element ID: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: banbooElementIDController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Element ID';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //CHARACTER DESCRIPTION
                TextFormField(
                  controller: banbooDescController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Character Description',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD32D25),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the character description';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                //TULISAN ADD CHARACTER IMAGE
                const SizedBox(
                  width: 380,
                  child: Text(
                    'Add Character Image',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 20,
                      fontFamily: 'HG-reg',
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                //BUTTON INPUT IMAGE
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        var pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          // Mengambil bytes dari gambar dan mengonversinya menjadi Uint8List
                          var imageBytes = await pickedImage.readAsBytes();
                          fileName = pickedImage.name;
                          setState(() {
                            banbooImageController =
                                imageBytes; // Simpan sebagai BLOB (Uint8List)
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFD32D25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Add Image'),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                //keterangan insert image
                Container(
                  child: fileName != null
                      ? SizedBox(
                          width: 380,
                          child: Text(
                            fileName!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                        )
                      : const SizedBox(
                          width: 380,
                          child: Text(
                            'No image selected',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 15,
                              fontFamily: 'HG-reg',
                            ),
                          ),
                        ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //BUTTON UPLOAD
                Form(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true &&
                          fileName != null) {
                        _insertOnPressed(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFD32D25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
