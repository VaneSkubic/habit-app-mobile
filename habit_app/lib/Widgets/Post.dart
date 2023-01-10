import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Post extends StatelessWidget {
  final profile;
  final first_name;
  final last_name;
  final caption;
  final media;
  final habit;

  const Post({
    super.key,
    required this.profile,
    required this.first_name,
    required this.last_name,
    required this.caption,
    required this.media,
    required this.habit,
  });

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
