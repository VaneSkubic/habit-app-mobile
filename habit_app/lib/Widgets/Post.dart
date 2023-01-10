import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Post extends StatelessWidget {
  final profile;
  final first_name;
  final last_name;
  final caption;
  final media;
  final habit;
  final is_admin;
  final post_id;
  final remove_post;

  const Post({
    super.key,
    required this.profile,
    required this.first_name,
    required this.last_name,
    required this.caption,
    required this.media,
    required this.habit,
    required this.is_admin,
    required this.post_id,
    required this.remove_post,
  });

  final storage = const FlutterSecureStorage();

  Future<String> getToken() async {
    var returnToken = await storage.read(key: 'token');
    if (returnToken != null) {
      return returnToken;
    } else {
      return '';
    }
  }

  void deletePost(int post_id) async {
    var token = await getToken();

    final response = await http.delete(
      Uri.parse('https://habit.gnus.co.uk/api/posts/$post_id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode > 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
    } else {
      var data = jsonDecode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(30),
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(profile)),
                SizedBox(width: 10),
                Text(first_name + ' ' + last_name),
                SizedBox(
                  width: 10,
                ),
                is_admin == '1'
                    ? ElevatedButton(
                        child: Icon(Icons.delete),
                        onPressed: () {
                          remove_post();
                          deletePost(post_id);
                        },
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 30),
            Text(caption),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(habit),
            ),
            SizedBox(height: 30),
            Image.network(media),
          ],
        ));
  }
}
