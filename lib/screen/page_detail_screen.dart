import 'package:banana/service/page_service.dart';
import 'package:flutter/material.dart';

class PageDetailScreen extends StatefulWidget {
  final String id;
  const PageDetailScreen({super.key, required this.id});

  @override
  State<PageDetailScreen> createState() => _PageDetailScreenState();
}

class _PageDetailScreenState extends State<PageDetailScreen> {
  dynamic _page = {};

  @override
  void initState() {
    super.initState();
    PageService.fetchPage(widget.id).then((page) {
      setState(() {
        _page = page;
      });
      print(_page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page['title']),
      ),
      body: Container(
        child: Text(_page['content']),
      ),
    );
  }
}
