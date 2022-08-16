import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statup/screens/add_business.dart';
import 'package:statup/screens/customise_savings.dart';
import 'package:statup/screens/explore.dart';
import 'package:statup/screens/profile.dart';
import 'package:statup/screens/set_savings.dart';
import 'package:statup/screens/transactions.dart';
import 'package:statup/services/others.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'deposit.dart';
import 'notifications.dart';
import 'onboarding/onboarding_one.dart';

class Landing extends StatefulWidget {
  const Landing();

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  myColors color = myColors();

  List allProducts = <Map<String, String>>[];
  List img = [];
  late DateTime currentBackPressTime;
  bool overallTargetVisibility = false;
  List? savingsPlans;
  bool extend = false;
  List? allSavingsPlans;
  int overallTarget = 0;
  int overallSavings = 0;
  String? cachedProfileImg = Hive.box("statup").get("profile_image");

  @override
  initState() {
    super.initState();

    Map<String, String> details = {
      'product_name': 'Crocs',
      'product_price': '1234',
      'product_description': 'Nice and friendly to wear',
      'sold': '12',
      'product_image':
          'https://cutewallpaper.org/21/nike-air-max-1-wallpaper/Black-And-Silver-Air-Force-Ones-28-Cool-Wallpaper-.jpeg'
    };

    details.forEach((k, v) => allProducts.add(details));

    // print("Ada Ganiru" + savingsPlans.toString());

    savingsPlans = Hive.box("statup").get("savings");

    if (savingsPlans != null) {
      print(savingsPlans.toString());
      allSavingsPlans = List.from(savingsPlans!.reversed);

      for (var i = 0; i < savingsPlans!.length; i++) {
        print(savingsPlans![i]["target"]);
        overallTarget =
            overallTarget + int.parse(allSavingsPlans![i]["target"]);
        overallSavings =
            overallSavings + int.parse(allSavingsPlans![i]["total_saved"]);
      }
    } else {
      allSavingsPlans = [];
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press back to exit app", gravity: ToastGravity.TOP);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Stack(children: [
          (Scaffold(
              backgroundColor: Colors.transparent,
              body: Scaffold(
                  drawer: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: NavDrawer(),
                  ),
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(27.0),
                      child: AppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.white,
                          elevation: 0.0,
                          title: Container(
                            width: double.maxFinite,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Builder(
                                    builder: (context) => IconButton(
                                      icon: const Icon(Icons.menu,
                                          size: 30,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      onPressed: () => Scaffold.of(context)
                                          .openDrawer(), // open side menu},
                                    ),
                                  ),

                                  Spacer(),

                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: (() {
                                            Get.to(Notifications());
                                          }),
                                          child: Container(
                                              child: SvgPicture.asset(
                                            "assets/images/svg/notification-svgrepo-com.svg",
                                            height: 23,
                                            width: 23,
                                            fit: BoxFit.scaleDown,
                                          ))),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(const Profile());
                                        },

                                        child: cachedProfileImg.toString() !=
                                                    "" &&
                                                cachedProfileImg.toString() !=
                                                    "null"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Image.network(
                                                    "https://statup.ng/statup/" +
                                                        cachedProfileImg
                                                            .toString(),
                                                    height: 14,
                                                    width: 14))
                                            : const Icon(Icons.account_circle,
                                                color: Colors.black, size: 22),

                                        //
                                      ),
                                    ],
                                  )
                                  // Your widgets here
                                ]),
                          ))),
                  body: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 3),
                          Center(
                              child: Column(
                            children: [
                              const Text("Overall Target",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.black)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      overallTargetVisibility == true
                                          ? "₦" + overallTarget.toString()
                                          : "--+--",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                      onTap: () => {
                                            setState(() {
                                              overallTargetVisibility =
                                                  !overallTargetVisibility;
                                            })
                                          },
                                      child: const Icon(Icons.visibility_off,
                                          size: 13, color: Colors.black))
                                ],
                              ),
                            ],
                          )),

                          SizedBox(height: 5),
                          //
                          Row(
                            children: [
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    padding: EdgeInsets.only(
                                        top: 22,
                                        bottom: 22,
                                        left: 10,
                                        right: 10),
                                    decoration: BoxDecoration(
                                      color: color.green(),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: double.maxFinite,
                                      child: Column(
                                        children: const [
                                          Text("Crushed Goals",
                                              style: TextStyle(
                                                  fontSize: 6,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          Text("₦0.00",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          36,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.6),
                                            spreadRadius: 3,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: GestureDetector(
                                          onTap: (() => Get.to(
                                                const OnboardingOne(),
                                              )),
                                          child: GestureDetector(
                                              onTap: (() => {
                                                    _showMaterialDialog(context)
                                                  }),
                                              child: Container(
                                                child: const Center(
                                                    child: Text("StaQ",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                padding:
                                                    const EdgeInsets.all(5),
                                              )))))
                            ],
                          ),
                          SizedBox(height: 5),
                          allSavingsPlans!.isNotEmpty
                              ? SizedBox(
                                  //height: extend == false ? 180 : 280,
                                  // constraints:
                                  //  BoxConstraints(minHeight: 180, ),

                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: extend == true
                                          ? allSavingsPlans!.length
                                          : allSavingsPlans!.length >= 2
                                              ? 2
                                              : allSavingsPlans!.length,
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      separatorBuilder: (c, i) {
                                        return const SizedBox(
                                          width: 10,
                                        );
                                      },
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String totalSaved =
                                            allSavingsPlans![index]
                                                ["total_saved"];

                                        String target =
                                            allSavingsPlans![index]["target"];

                                        int percentageCrushed =
                                            percentageAchieved(
                                                int.parse(totalSaved),
                                                int.parse(target));

                                        return Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: Row(children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        allSavingsPlans![index]
                                                                    ["name"] ==
                                                                "business-default"
                                                            ? "Business"
                                                            : ["name"] ==
                                                                    "rent-default"
                                                                ? "Rent"
                                                                : allSavingsPlans![
                                                                        index]
                                                                    ["name"],
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                color.green(),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    const SizedBox(width: 5),
                                                    const Icon(Icons.lock,
                                                        color: Colors.black,
                                                        size: 10),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                const SizedBox(width: 40),
                                                Row(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    SvgPicture.asset(
                                                      "assets/images/svg/target.svg",
                                                      height: 13,
                                                      color: color.green(),
                                                      width: 13,
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        "₦" +
                                                            allSavingsPlans![
                                                                        index]
                                                                    ["target"]
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    const SizedBox(width: 5),
                                                    const Icon(
                                                        Icons.visibility_off,
                                                        color: Colors.black,
                                                        size: 10),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                    percentageCrushed
                                                            .toString() +
                                                        "% Achieved",
                                                    style: const TextStyle(
                                                        fontSize: 7,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            const Spacer(),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: 23),
                                                    GestureDetector(
                                                        onTap: (() => Get.to(Deposit(
                                                            savingsID:
                                                                allSavingsPlans?[
                                                                        index]
                                                                    ["id"],
                                                            savingsName:
                                                                allSavingsPlans?[
                                                                        index]
                                                                    ["name"],
                                                            target:
                                                                allSavingsPlans?[
                                                                        index]
                                                                    ["target"],
                                                            totalSaved:
                                                                allSavingsPlans?[
                                                                        index]
                                                                    ["total_saved"]))),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .circlePlus,
                                                          color: color.green(),
                                                          size: 15,
                                                        )),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 14),
                                                    Column(
                                                      children: [
                                                        const Text("Interest",
                                                            style: TextStyle(
                                                                fontSize: 7,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                        const Text("₦0.00",
                                                            style: TextStyle(
                                                                fontSize: 9,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            )
                                          ]),
                                          width: double.maxFinite,
                                          padding: const EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                              top: 7,
                                              bottom: 7),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: color.grey2()),
                                        );
                                      }))
                              //This second container has a shorter height

                              : const SizedBox(),

                          extend == true
                              ? const SizedBox(height: 5)
                              : SizedBox(height: 4),

                          allSavingsPlans!.isEmpty ||
                                  extend == true ||
                                  allSavingsPlans!.length == 1
                              ? Container(
                                  child: Row(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Business",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: color.green(),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.lock,
                                                color: Colors.black, size: 10),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const SizedBox(width: 40),
                                        Row(
                                          children: [
                                            const SizedBox(height: 10),
                                            SvgPicture.asset(
                                              "assets/images/svg/target.svg",
                                              height: 13,
                                              color: color.green(),
                                              width: 13,
                                              fit: BoxFit.scaleDown,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text("₦0.00",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.visibility_off,
                                                color: Colors.black, size: 10),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        const Text("0% Achieved",
                                            style: TextStyle(
                                                fontSize: 7,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 14),
                                          GestureDetector(
                                              onTap: (() =>
                                                  Get.to(const SetSavings(
                                                    defaultSavingsName:
                                                        "business-default",
                                                  ))),
                                              child: Icon(
                                                FontAwesomeIcons.circlePlus,
                                                color: color.green(),
                                                size: 15,
                                              ))
                                        ]),
                                        const SizedBox(height: 10),
                                        Column(children: [
                                          SizedBox(width: 14),
                                          const Text("Interest",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          const Text("₦0.00",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ])
                                      ],
                                    )
                                  ]),
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 7),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: color.grey2()),
                                )
                              : const SizedBox(),
                          extend == true
                              ? const SizedBox(height: 5)
                              : SizedBox(),

                          allSavingsPlans!.isEmpty || extend == true
                              ? Container(
                                  child: Row(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Rent",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: color.green(),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.lock,
                                                color: Colors.black, size: 10),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        const SizedBox(width: 40),
                                        Row(
                                          children: [
                                            const SizedBox(height: 10),
                                            SvgPicture.asset(
                                              "assets/images/svg/target.svg",
                                              height: 12,
                                              color: color.green(),
                                              width: 12,
                                              fit: BoxFit.scaleDown,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text("₦0.00",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.visibility_off,
                                                color: Colors.black, size: 10),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text("0% Achieved",
                                            style: const TextStyle(
                                                fontSize: 7,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 14),
                                          GestureDetector(
                                              onTap: (() =>
                                                  Get.to(const SetSavings(
                                                    defaultSavingsName:
                                                        "rent-default",
                                                  ))),
                                              child: Icon(
                                                FontAwesomeIcons.circlePlus,
                                                color: color.green(),
                                                size: 15,
                                              ))
                                        ]),
                                        const SizedBox(height: 10),
                                        Column(children: [
                                          SizedBox(width: 14),
                                          const Text("Interest",
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          const Text("₦0.00",
                                              style: TextStyle(
                                                  fontSize: 7,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ])
                                      ],
                                    )
                                  ]),
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: color.grey1()),
                                )
                              : const SizedBox(),

                          GestureDetector(
                              onTap: () => {
                                    setState(() {
                                      extend = !extend;

                                      print(extend.toString());
                                    })
                                  },
                              child: Center(
                                  child: SvgPicture.asset(
                                "assets/images/svg/down-outlined-arrow-down.svg",
                                height: 18,
                                color: color.green(),
                                width: 18,
                                fit: BoxFit.scaleDown,
                              ))),
                          const SizedBox(height: 1),

                          FutureBuilder(
                              future: Others().getProducts(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return loader();
                                } else {
                                  if (snapshot.data.isNotEmpty &&
                                      snapshot.data != null) {
                                    List? products = snapshot.data;
                                    return SizedBox(
                                        height: (Get.height * 0.6) - 20,
                                        width: double.maxFinite,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: products!.length,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          separatorBuilder: (c, i) {
                                            return const SizedBox(width: 10);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                                width: Get.width - 50,
                                                height: 100,
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://statup.ng/statup/" +
                                                                products[index]
                                                                    ["image"],
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        height: 270,
                                                        placeholder:
                                                            (ctx, text) {
                                                          return loader();
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 1),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                products[index][
                                                                    "product_name"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            const SizedBox(
                                                                height: 2),
                                                            Text(
                                                                products[index][
                                                                    "product_desc"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Column(
                                                          children: [
                                                            Text(
                                                                "₦" +
                                                                    products[index]
                                                                        [
                                                                        "product_price"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: color
                                                                        .green(),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                    "Sold",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    width: 5),
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      border: Border.all(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              207,
                                                                              207,
                                                                              207))),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3),
                                                                  child: Text(
                                                                      products[
                                                                              index]
                                                                          [
                                                                          "sold"],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        elevation: 10,
                                                        shadowColor:
                                                            Color.fromARGB(255,
                                                                209, 209, 209),
                                                        child: Container(
                                                            height: 30,
                                                            width:
                                                                double
                                                                    .maxFinite,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: color
                                                                  .orange(),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    25.0),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: const Text(
                                                                  "Buy",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            )
                                                            //rest of the existing code
                                                            ))
                                                  ],
                                                ));
                                          },
                                        ));
                                  } else {
                                    return Container(
                                        child: const Center(
                                      child:
                                          Text("Could Not Retrieve Products"),
                                    ));
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  )))),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  height: 44,
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          GestureDetector(
                            onTap: (() {
                              Get.to(const CustomiseGoals());
                            }),
                            child: SvgPicture.asset(
                              "assets/images/svg/customize.svg",
                              height: 29,
                              width: 29,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const Text("Customise",
                              style: TextStyle(
                                  fontSize: 7,
                                  // fontFamily: 'BonvenoCF-Light',
                                  decoration: TextDecoration.none,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          GestureDetector(
                              onTap: (() {
                                Get.to(const AddBusiness());
                              }),
                              child: SvgPicture.asset(
                                "assets/images/svg/invoice.svg",
                                height: 29,
                                width: 29,
                                fit: BoxFit.scaleDown,
                              )),
                          const Text("Invoice",
                              style: TextStyle(
                                  fontSize: 7,
                                  // fontFamily: 'BonvenoCF-Light',
                                  decoration: TextDecoration.none,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          GestureDetector(
                              onTap: (() {
                                Get.to(const Transaction());
                              }),
                              child: SvgPicture.asset(
                                "assets/images/svg/transactions.svg",
                                height: 29,
                                width: 29,
                                fit: BoxFit.scaleDown,
                              )),
                          const Text("Transactions",
                              style: TextStyle(
                                  fontSize: 7,
                                  // fontFamily: 'BonvenoCF-Light',
                                  decoration: TextDecoration.none,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          GestureDetector(
                              onTap: (() {
                                Get.to(const Explore());
                              }),
                              child: SvgPicture.asset(
                                "assets/images/svg/explore.svg",
                                height: 29,
                                width: 29,
                                fit: BoxFit.scaleDown,
                              )),
                          const Text("Explore",
                              style: TextStyle(
                                  fontSize: 7,
                                  // fontFamily: 'BonvenoCF-Light',
                                  decoration: TextDecoration.none,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  )),
            ],
          )
        ]));
  }

  int percentageAchieved(int totalSaved, int target) {
    double percentage = (totalSaved / target) * 100;
    return percentage.round();
  }

  void _showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
                width: 250,
                height: 150,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Center(
                    child: Text("Coming Soon",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)))),
          ),
        ),
      ),
    );
  }
}
