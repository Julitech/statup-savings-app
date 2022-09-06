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
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: GestureDetector(
                  onTap: () {
                    Get.to(Landing(
                      notif_count: "0",
                      prev: "notif",
                    ));
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )

                  //
                  ),
              // ignore: prefer_const_literals_to_create_immutables

              title: Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                  color: color.green(),
                ),
              ),
            ),
            body: FutureBuilder(
                future: Savings().notifications(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return loader();
                  } else if (snapshot.data.isNotEmpty &&
                      snapshot.data != null) {
                    if (snapshot.data.isNotEmpty && snapshot.data != null) {
                      return FutureBuilder(
                          future: Savings().update_notifications(),
                          builder: (context, AsyncSnapshot snapshot1) {
                            if (!snapshot1.hasData) {
                              return loader();
                            } else if (snapshot1.data != null) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  color: Colors.white,
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 18,
                                            right: 18),
                                        child: const Text("New",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        decoration: BoxDecoration(
                                            color: color.green(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                          width: double.maxFinite,
                                          height: Get.height - 60,
                                          child: ListView.separated(
                                              itemCount: snapshot.data.length,
                                              scrollDirection: Axis.vertical,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                    height: 20);
                                              },
                                              padding: const EdgeInsets.all(10),
                                              itemBuilder: (context, index) {
                                                List? notifications =
                                                    snapshot.data;
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        notifications![index]
                                                            ["heading"],
                                                        style: TextStyle(
                                                            color:
                                                                color.green(),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(height: 3),
                                                    Text(
                                                        notifications![index]
                                                            ["body"],
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 37, 37, 37),
                                                          fontSize: 13,
                                                        )),
                                                  ],
                                                );
                                              })),
                                      Divider(height: 1, color: color.grey2())
                                    ],
                                  )));
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  }
                  return Container();
                })));
  }

  Future<bool> _onWillPop() async {
    if (1 == 1) {
      Get.to(const Landing(
        prev: "notif",
        notif_count: 0,
      ));
    }

    return false;
  }
}
