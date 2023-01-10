import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Logout extends StatelessWidget {
  Logout({super.key});

  final storage = const FlutterSecureStorage();
  String token = '';

  Future<String> getToken() async {
    var returnToken = await storage.read(key: 'token');
    if (returnToken != null) {
      return returnToken;
    } else {
      return '';
    }
  }

  void logout() async {
    token = await getToken();

    final response = await http.post(
      Uri.parse('https://habit.gnus.co.uk/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
      onPressed: () {
        logout();
        Navigator.pop(context);
      },
    );
  }
}
