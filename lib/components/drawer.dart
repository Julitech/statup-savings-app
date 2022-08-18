import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/screens/more.dart';
import '/screens/signup_login.dart';
import '../screens/tab_in.dart';
import 'colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    myColors color = myColors();
    return Drawer(
        child: Column(
      children: [
        Container(
            // padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            width: double.maxFinite,
            height: 60.0,
            color: color.green()),
        SizedBox(height: 20),
        Center(
            child: GestureDetector(
                onTap: () => Get.to(const More()),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SvgPicture.asset(
                      "assets/images/svg/more.svg",
                      height: 21,
                      color: color.green(),
                      width: 21,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("More",
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                ))),
        Spacer(),
        Center(
          child: GestureDetector(
              onTap: () => {
                    Hive.box('statup').delete('access_token'),
                    Hive.box('statup').delete('savings'),
                    Hive.box('statup').delete('businesses'),
                    Hive.box('statup').delete('first_name'),
                    Hive.box('statup').delete('last_name'),
                    Hive.box('statup').delete('email'),
                    Hive.box('statup').delete('loggedIn'),
                    Hive.box('statup').delete('pin'),
                    Get.offAll(TabsIn())
                  },
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  SvgPicture.asset(
                    "assets/images/svg/logout.svg",
                    height: 21,
                    color: Color.fromARGB(255, 212, 12, 12),
                    width: 21,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Text("Logout",
                      style: TextStyle(
                          color: Color.fromARGB(255, 212, 12, 12),
                          fontSize: 15)),
                ],
              )),
        ),
        SizedBox(height: 100)
      ],
    ));
  }
}
