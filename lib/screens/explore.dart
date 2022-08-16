import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/colors.dart';
import '../components/constants.dart';
import '../services/others.dart';
import '../services/savings.dart';
import 'landing.dart';
import 'profile.dart';

class Explore extends StatefulWidget {
  const Explore({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
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
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )

              //
              ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Center(
            child: Text(
              "",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: Others().getProducts(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return loader();
                  } else {
                    if (snapshot.data.isNotEmpty && snapshot.data != null) {
                      List? products = snapshot.data;
                      return Material(
                          elevation: 10,
                          shadowColor: Color.fromARGB(255, 209, 209, 209),
                          child: Container(
                              padding: EdgeInsets.only(bottom: 20),
                              color: Colors.white,
                              width: double.maxFinite,
                              height: Get.height * 0.30,
                              child: ListView.separated(
                                  itemCount: products!.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                  padding: const EdgeInsets.all(10),
                                  itemBuilder: (context, index) {
                                    return Row(children: [
                                      Container(
                                          padding: EdgeInsets.all(10),
                                          height: 160,
                                          width: 160,
                                          child: Column(
                                            children: [
                                              Image.network(
                                                "https://statup.ng/statup/" +
                                                    products![index]["image"],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 5),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 0,
                                                          ),
                                                          child: Container(
                                                              width: 80,
                                                              child: Text(
                                                                products[index][
                                                                    "product_name"],
                                                                style: const TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: 20,
                                                          ),
                                                          child: Text(
                                                            "₦" +
                                                                products[index][
                                                                    "product_price"],
                                                            style: TextStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: color
                                                                    .green()),
                                                          ))
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      decoration: BoxDecoration(
                                                          color: color.green2(),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                      child: Text("Buy",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: color
                                                                  .green())))
                                                ],
                                              )
                                            ],
                                          )),
                                      VerticalDivider(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 214, 214, 214),
                                      )
                                    ]);
                                  })));
                    } else {
                      return Container(
                          child: const Center(
                              child: Text("Could Not Load Products")));
                    }
                  }
                }),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 6,
                  child: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Set Financial Goals",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white)),
                          SizedBox(height: 10),
                          Text(
                              "One way to not run out of funds is by planning. A second way is by... Read More",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white))
                        ],
                      ))),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              height: 260,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 6,
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: Image.network(
                        "https://statup.ng/statup/explore_images/20220814_191950.jpg"),
                  )),
            )
          ],
        ));
  }
}
