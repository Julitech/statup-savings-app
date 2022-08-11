import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/colors.dart';
import '../components/constants.dart';
import '../services/savings.dart';
import 'landing.dart';
import 'profile.dart';

class Referrals extends StatefulWidget {
  const Referrals({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _ReferralsState createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> {
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
                Get.back;
              },
              child: Icon(Icons.arrow_back)

              //
              ),
          backgroundColor: color.green(),
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Center(
            child: Text(
              "Withdrawal",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: Get.back,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ))
          ],
        ),
        body: Container());
  }
}
