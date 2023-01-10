import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final storage = const FlutterSecureStorage();
  final _captionController = TextEditingController();
  File? _image;
  final _imagePicker = ImagePicker();
  bool isLoading = false;

  Future<String> getToken() async {
    var returnToken = await storage.read(key: 'token');
    if (returnToken != null) {
      return returnToken;
    } else {
      return '';
    }
  }

  void _sendPost(String caption, File image) async {
    try {
      var token = await getToken();
      var uri = Uri.parse("https://habit.gnus.co.uk/api/posts/create");
      var request = new MultipartRequest("POST", uri);

      // create multipart using filepath, string or bytes
      var multipartFile = await http.MultipartFile.fromPath(
        'media',
        image.path,
      );
      // add file to multipart
      request.files.add(multipartFile);

      request.fields['caption'] = caption;
      request.fields['habit_id'] = '1';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ' + token;

      setState(() {
        isLoading = true;
      });
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      setState(() {
        isLoading = false;
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Post sent successfully');
        Navigator.pop(context);
      } else {
        print(
            'An error occurred while sending the post. ${response.reasonPhrase}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'An error occurred while sending the post. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    hintText: 'Enter a caption...',
                  ),
                ),
                SizedBox(height: 16.0),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Pick an image'),
                  onPressed: () async {
                    final pickedFile = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    setState(() {
                      _image = File.fromUri(Uri.parse(pickedFile!.path));
                    });
                  },
                ),
                SizedBox(height: 16.0),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text('Send'),
                        onPressed: () {
                          if (_image == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('You must pick an image.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          _sendPost(_captionController.text, _image!);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
