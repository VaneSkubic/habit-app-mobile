import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habit_app/Screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String _caption = '';
  String content = '';
  String token = '';
  String base = '';
  Future<Uint8List>? imageBytes;

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageBytes = image!.readAsBytes();
  }

  Future<String> getToken() async {
    var returnToken = await storage.read(key: 'token');
    if (returnToken != null) {
      return returnToken;
    } else {
      return '';
    }
  }

  void post() async {
    token = await getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://habit.gnus.co.uk/api/posts/create'),
    );

    // var imageData = imageBytes.buffer.asUint8List();

    // if (imageBytes != null) {
    //   var image = http.MultipartFile.fromBytes('image', imageData,
    //       filename: 'image.png');
    //   request.files.add(image);
    // }

    request.fields['caption'] = 'test';
    var response = await request.send();

    // final response = await http.post(
    //   Uri.parse('https://habit.gnus.co.uk/api/posts/create'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: '''{
    //     "media": "null",
    //     "caption": "$_caption",
    //     "habit_id": "1"
    //   }''',
    // );

    // if (response.statusCode > 200 && response.statusCode < 300) {
    //   _caption = '';

    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => HomeScreen(),
    //     ),
    //   );
    //   setState(() {
    //     content = data;
    //   });
    // } else {
    //   setState(() {
    //     content = response.body;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Caption'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onChanged: (value) => _caption = value != null ? value : '',
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                "Pick Image from Camera",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                pickImage();
              },
            ),
            SizedBox(height: 20),
            // Text(content),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // post();
              },
              child: Text('Make Post'),
            ),
            Text(content.length > 300 ? content.substring(0, 300) : ''),
          ],
        ),
      ),
    );
  }
}
