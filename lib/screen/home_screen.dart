import 'dart:convert';
import 'package:banana/config/app.dart';
import 'package:banana/screen/page_detail_screen.dart';
import 'package:banana/service/auth_service.dart';
import 'package:banana/service/page_service.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pages = [];
  List<dynamic> banners = [];

  Future<void> fetchBanners() async {
    try {
      final response = await http.get(Uri.parse('$API_URL/api/banners'));
      final banners = jsonDecode(response.body);
      print(banners);
      setState(() {
        this.banners = banners;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchPages() async {
    try {
      List<dynamic> pages = await PageService.fetchPages();
      setState(() {
        this.pages = pages;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    AuthService.checkLogin().then((loggedIn) {
      if (!loggedIn) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
    fetchBanners();
    fetchPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                child: Column(
                  children: [Text('MANU')],
                ),
              ),
            ),
            // Add your drawer items here
            ListView.builder(
              shrinkWrap: true,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PageDetailScreen(
                          id: pages[index]['id'],
                        ),
                      ),
                    );
                  },
                  title: Column(
                    children: [
                      Text(pages[index]['title']),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Center(
              child: Container(
                width: 400,
                height: 400,
                child: Swiper(
                  autoplay: true,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          API_URL + banners[index]['imageUrl'],
                          alignment: AlignmentDirectional.topCenter,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
