import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_app/Screens/NewPostScreen.dart';
import 'package:habit_app/Widgets/Logout.dart';
import 'package:habit_app/Widgets/LeftDrawer.dart';

import '../Widgets/Feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  String content = 'test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        title: Text('Feed'),
        // automaticallyImplyLeading: false,
        actions: [
          Logout(),
        ],
      ),
      body: Feed(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewPostScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
