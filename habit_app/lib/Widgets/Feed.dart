import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:habit_app/Widgets/Post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final storage = const FlutterSecureStorage();
  String token = '';
  String isAdmin = '';
  String content = 'test';
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getIsAdmin();
    getPosts();
  }

  void getIsAdmin() async {
    var returnToken = await storage.read(key: 'is_admin');
    setState(() {
      isAdmin = returnToken!;
    });
  }

  Future<String> getToken() async {
    var returnToken = await storage.read(key: 'token');
    if (returnToken != null) {
      return returnToken;
    } else {
      return '';
    }
  }

  void getPosts() async {
    token = await getToken();
    setState(() {
      content = token;
    });

    final response = await http.get(
      Uri.parse('https://habit.gnus.co.uk/api/feed'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode > 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      setState(() {
        posts = data['data'];
      });
    } else {
      var data = jsonDecode(response.body);
      setState(() {
        posts = data['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Post(
            is_admin: isAdmin,
            profile: posts[index]['user']['media']['media_url'],
            first_name: posts[index]['user']['first_name'],
            last_name: posts[index]['user']['last_name'],
            caption: posts[index]['caption'],
            media: posts[index]['media']['media_url'],
            habit: posts[index]['habit']['name'],
            post_id: posts[index]['id'],
            remove_post: () {
              setState(() {
                posts.removeAt(index);
              });
            },
          );
        },
      );
    }
  }
}
