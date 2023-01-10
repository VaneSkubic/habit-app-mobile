import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'RegisterScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _passwordConf = '';
  String _firstName = '';
  String _lastName = '';
  String _username = '';
  String content = '';

  final storage = new FlutterSecureStorage();

  Future setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  void register() async {
    final response = await http.post(
      Uri.parse('https://habit.gnus.co.uk/api/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: '''{
        "email": "$_email",
        "password": "$_password",
        "password_confirmation": "$_passwordConf",
        "first_name": "$_firstName",
        "last_name": "$_lastName",
        "username": "$_username"
      }''',
    );

    if (response.statusCode > 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      await setToken(data['token']);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      var data = jsonDecode(response.body);
      setState(() {
        content = data['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'First name'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onChanged: (value) => _firstName = value != null ? value : '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last name'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onChanged: (value) => _lastName = value != null ? value : '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  onChanged: (value) => _username = value != null ? value : '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  onChanged: (value) => _email = value != null ? value : '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onChanged: (value) => _password = value != null ? value : '',
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Password confirmation'),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please repeat the password';
                    }
                    return null;
                  },
                  onChanged: (value) =>
                      _passwordConf = value != null ? value : '',
                ),
                ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text('Already a user? Login here!'),
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
