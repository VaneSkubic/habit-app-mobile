import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String content = '';
  bool isLoading = false;

  final storage = new FlutterSecureStorage();

  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  Future setToken(String token, int is_admin) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'is_admin', value: is_admin.toString());
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse('https://habit.gnus.co.uk/api/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: '''{
        "email": "$_email",
        "password": "$_password"
      }''',
    );
    setState(() {
      isLoading = false;
    });

    if (response.statusCode > 200 && response.statusCode < 300) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);

      await setToken(data['token'], data['user']['is_admin']);
      _email = '';
      _password = '';
      emailText.clear();
      passwordText.clear();
      emailFocus.unfocus();
      passwordFocus.unfocus();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      setState(() {
        content = data['token'];
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        content = 'login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: emailText,
              focusNode: emailFocus,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onChanged: (value) => _email = value != null ? value : '',
            ),
            TextFormField(
              controller: passwordText,
              focusNode: passwordFocus,
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
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: Text('Don\'t have an account? Register here'),
            ),
            // Text(
            //   content,
            //   style: TextStyle(fontSize: 20),
            // ),
          ],
        ),
      ),
    );
  }
}
