import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  final storage = const FlutterSecureStorage();
  String token = '';
  String isAdmin = '';
  String first_name = '';
  String last_name = '';
  String photo = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getIsAdmin();
    getUser();
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

  void getUser() async {
    token = await getToken();

    final response = await http.get(
      Uri.parse('https://habit.gnus.co.uk/api/user'),
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
        first_name = data['data']['first_name'];
        last_name = data['data']['last_name'];
        photo = data['data']['media']['media_url'];
      });
    } else {
      var data = jsonDecode(response.body);
      setState(() {
        first_name = data['data']['first_name'];
        last_name = data['data']['last_name'];
        photo = data['data']['media']['media_url'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(photo)),
                    SizedBox(width: 10),
                    Text(
                      first_name + ' ' + last_name,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  isAdmin == '1' ? 'Admin' : 'User',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
