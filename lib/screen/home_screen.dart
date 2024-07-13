import 'dart:convert';
import 'package:banana/config/app.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var ListData = [];
  Future<void> _getbanner() async {
    final resonse = await http.get(
      Uri.parse('$API_URL/api/banners'),
      headers: {"accept": "application/json"},
    );
    setState(() {
      ListData = jsonDecode(resonse.body);
    });
    List<Map<String, dynamic>> ImagesURL = ListData.map((e) => {
          'imageUrl': '$API_URL${e['imageUrl']}',
        }).toList();
    setState(() {
      ListData = ImagesURL.expand((e) => [e]).toList();
    });
    print(ListData);
  }

  @override
  void initState() {
    super.initState();
    _getbanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: 400,
        height: 400,
        child: Swiper(
          autoplay: true,
          itemCount: ListData.length,
          itemBuilder: (context, index) {
            return Image.network(ListData[index]['imageUrl']);
          },
        ),
      ),
    ));
  }
}
