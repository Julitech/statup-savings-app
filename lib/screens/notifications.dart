import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/colors.dart';
import '../components/constants.dart';
import '../services/savings.dart';
import 'landing.dart';
import 'profile.dart';

class Notifications extends StatefulWidget {
  const Notifications({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  myColors color = myColors();

  String? cachedProfileImg = Hive.box("statup").get("profile_image");

  @override
  void initState() {
    // _node = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.to(const Profile());
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              )

              //
              ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: Center(
            child: Text(
              "Notifications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: color.green(),
              ),
            ),
          ),
        ),
        body: Container());
  }
}
