import 'package:banboo_store/helper/auth_service.dart';
import 'package:banboo_store/models/banboo.dart';
import 'package:banboo_store/product_page.dart';
import 'package:banboo_store/profile_page.dart';
import 'package:banboo_store/search_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  List<Banboo>? _banboos; // Data API
  bool _isLoading = true; // Status loading

  void signOutGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }

  @override
  void initState() {
    signOutGoogle();
    super.initState();
    _pageController = PageController();

    // Timer untuk carousel
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    // Fetch data API
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await fetchBanboos();
      setState(() {
        _banboos = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<List<Banboo>> fetchBanboos() async {
    const url = "http://10.0.2.2:3000/banboos/";
    var token = AuthService.loggedUser!.token;
    final response = await http.get(Uri.parse(url), headers: {'token': token});
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Banboo.fromJson(data)).toList();
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int myIndex = 0;
  List<Widget> get widgetList => [
        SearchPage(),
        ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: myIndex,
              children: [
                MainPageContent(
                  pageController: _pageController,
                  isLoading: _isLoading,
                  banboos: _banboos,
                ),
                ...widgetList,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFD32D25),
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 25),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MainPageContent extends StatelessWidget {
  final PageController pageController;
  final bool isLoading;
  final List<Banboo>? banboos;

  const MainPageContent({
    super.key,
    required this.pageController,
    required this.isLoading,
    required this.banboos,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo dan Keranjang
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/ui_component/logo.png',
                        width: 70, height: 43),
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
                        icon:
                            Image.asset('assets/ui_component/market.png'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Image Carousel
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index) {
                    return Image.asset(imagePaths[index], fit: BoxFit.cover);
                  },
                ),
              ),

              const SizedBox(height: 14),

              //PEMBATAS
              Container(
                height: 4,
                color: const Color.fromARGB(255, 237, 237, 237),
              ),

              const SizedBox(height: 20),

              //TULISAN BANBOO
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'All Banboo',
                  style: TextStyle(
                    fontFamily: 'HG-medium',
                    fontSize: 15,
                  ),
                ),
              ),

              // Grid View Data Banboos
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : banboos != null && banboos!.isNotEmpty
                      ? GridView.builder(
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
                          itemCount: banboos!.length,
                          itemBuilder: (context, index) {
                            final banboo = banboos![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      banboo_id: banboo.banboo_id,
                                      price: banboo.price,
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
                                    banboo.banboo_image.isNotEmpty
                                        ? Image.memory(
                                            base64Decode(banboo.banboo_image),
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
                                      banboo.banboo_name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'HG-medium',
                                      ),
                                    ),
                                    Text(
                                      'Rp${banboo.price.toString()}',
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
                        )
                      : const Center(child: Text('No data available')),
            ],
          ),
        ),
      ),
    );
  }
}

const List<String> imagePaths = [
  "assets/ui_component/poster-1.png",
  "assets/ui_component/poster-2.png",
  "assets/ui_component/poster-3.png",
];
