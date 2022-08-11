import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:statup/screens/settings.dart';
import '../components/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class More extends StatelessWidget {
  const More({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    myColors color = myColors();
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: const Icon(Icons.arrow_back)),
                const Spacer(),
                const Spacer()
              ],
            ),
            width: double.maxFinite,
            height: 100.0,
            color: color.green()),

        //Menu Items
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/referral.svg",
                height: 21,
                width: 21,
                color: color.green(),
                fit: BoxFit.scaleDown,
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Refer A Friend And Earn N500',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {},
            )),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: Icon(Icons.settings, color: color.green(), size: 23),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Manage Your App Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {Get.to(Settings())},
            )),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/review.svg",
                height: 21,
                width: 21,
                fit: BoxFit.scaleDown,
                color: color.green(),
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review StatUp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Rate Us On Appstore',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {},
            )),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/share-svgrepo-com.svg",
                height: 21,
                width: 21,
                fit: BoxFit.scaleDown,
                color: color.green(),
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share StatUp',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Share StatUp With Your Friends',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {},
            )),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/contact-support-svgrepo-com.svg",
                height: 21,
                width: 21,
                fit: BoxFit.scaleDown,
                color: color.green(),
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Reach Out To Us For Support',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {},
            )),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/legal.svg",
                height: 21,
                width: 21,
                fit: BoxFit.scaleDown,
                color: color.green(),
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Learn More About StartUp Policies',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 13),
                    ),
                  ]),
              onTap: () => {},
            )),
      ],
    ));
  }
}
