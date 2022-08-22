import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screens/add_business.dart';
import '/screens/customise_savings.dart';
import '/screens/explore.dart';
import '/screens/profile.dart';
import '/screens/set_savings.dart';
import '/screens/transactions.dart';
import '/services/Invoice.dart';
import '/screens/purchase.dart';
import '/services/others.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_search2/dropdown_search2.dart';
import 'deposit.dart';
import 'notifications.dart';
import 'onboarding/onboarding_one.dart';
import '../components/states.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Landing extends StatefulWidget {
  const Landing();

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  myColors color = myColors();
  States states = States();
  String platform = "";
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
  bool showBusinessPlan = true;
  bool showRentPlan = true;
  int _selectedIndex = 0;
  bool updateNotif = false;
  TextEditingController _phoneController = TextEditingController();
  String state = "Select State";

  @override
  initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      // _showMaterialDialog2(context);
      /*setState(() {
        welcomeGIFVisible = false;
      });*/
    });

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
        if (allSavingsPlans![i]["name"] == "business-default") {
          setState(() {
            showBusinessPlan = false;
          });
        }
        if (allSavingsPlans![i]["name"] == "rent-default") {
          setState(() {
            showRentPlan = false;
          });
        }
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
    if (now.difference(currentBackPressTime) < const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press back to exit app", gravity: ToastGravity.TOP);
      return Future.value(true);
    }
    return Future.value(true);
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      //style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      // style: optionStyle,
    ),
    Text(
      'Index 2: School',
      // style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Get.to(const CustomiseGoals());
      } else if (index == 1) {
        Get.to(AddBusiness());
      } else if (index == 2) {
        Get.to(Transaction());
      } else if (index == 3) {
        Get.to(Explore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(Get.height.toString());

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
                  bottomNavigationBar: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/svg/customize.svg",
                          height: 29.sp,
                          width: 29.sp,
                          fit: BoxFit.scaleDown,
                        ),
                        label: 'Customise',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/svg/invoice.svg",
                          height: 29.sp,
                          width: 29.sp,
                          fit: BoxFit.scaleDown,
                        ),
                        label: 'Invoice',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/svg/transactions.svg",
                          height: 29.sp,
                          width: 29.sp,
                          fit: BoxFit.scaleDown,
                        ),
                        label: 'Transactions',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/images/svg/explore.svg",
                          height: 29.sp,
                          width: 29.sp,
                          fit: BoxFit.scaleDown,
                        ),
                        label: 'Explore',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Color.fromARGB(255, 24, 24, 24),
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    onTap: _onItemTapped,
                    selectedLabelStyle: TextStyle(
                        fontSize: 7.sp,
                        // fontFamily: 'BonvenoCF-Light',
                        decoration: TextDecoration.none,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.normal),
                    unselectedLabelStyle: TextStyle(
                        fontSize: 7.sp,
                        // fontFamily: 'BonvenoCF-Light',
                        decoration: TextDecoration.none,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.normal),
                  ),
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(27.0.sp),
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
                                      icon: Icon(Icons.menu,
                                          size: 30.sp,
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
                                            height: 23.h,
                                            width: 23.w,
                                            fit: BoxFit.scaleDown,
                                          ))),
                                      SizedBox(width: 20.w),
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
                                                    height: 14.h,
                                                    width: 14.w))
                                            : Icon(Icons.account_circle,
                                                color: Colors.black,
                                                size: 22.sp),

                                        //
                                      ),
                                    ],
                                  )
                                  // Your widgets here
                                ]),
                          ))),
                  body: extend == true
                      ? //enable scrolling
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 3.h),
                                Center(
                                    child: Column(
                                  children: [
                                    Text("Overall Target",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.sp,
                                            color: Colors.black)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            overallTargetVisibility == true
                                                ? "₦" + overallTarget.toString()
                                                : "--+--",
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        SizedBox(width: 5.w),
                                        GestureDetector(
                                            onTap: () => {
                                                  setState(() {
                                                    overallTargetVisibility =
                                                        !overallTargetVisibility;
                                                  })
                                                },
                                            child: Icon(Icons.visibility_off,
                                                size: 13.sp,
                                                color: Colors.black))
                                      ],
                                    ),
                                  ],
                                )),

                                SizedBox(height: 5.h),
                                //
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              20,
                                      child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          padding: EdgeInsets.only(
                                              top: 22.sp,
                                              bottom: 22.sp,
                                              left: 10.sp,
                                              right: 10.sp),
                                          decoration: BoxDecoration(
                                            color: color.green(),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24.sp)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.6),
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
                                              children: [
                                                Text("Crushed Goals",
                                                    style: TextStyle(
                                                        fontSize: 6.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "₦" +
                                                        overallSavings
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 9.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                36,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20.sp, bottom: 20.sp),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24.sp)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
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
                                                          _showMaterialDialog(
                                                              context)
                                                        }),
                                                    child: Container(
                                                      child: Center(
                                                          child: Text("StaQ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      padding:
                                                          EdgeInsets.all(5.sp),
                                                    )))))
                                  ],
                                ),
                                SizedBox(height: 5.h),
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
                                            physics:
                                                const BouncingScrollPhysics(),
                                            separatorBuilder: (c, i) {
                                              return SizedBox(
                                                height: 5.sp,
                                              );
                                            },
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              String totalSaved =
                                                  allSavingsPlans![index]
                                                      ["total_saved"];

                                              String target =
                                                  allSavingsPlans![index]
                                                      ["target"];

                                              int percentageCrushed =
                                                  percentageAchieved(
                                                      int.parse(totalSaved),
                                                      int.parse(target));

                                              return Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                child: Row(children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              allSavingsPlans![
                                                                              index]
                                                                          [
                                                                          "name"] ==
                                                                      "business-default"
                                                                  ? "Business"
                                                                  : ["name"] ==
                                                                          "rent-default"
                                                                      ? "Rent"
                                                                      : allSavingsPlans![
                                                                              index]
                                                                          [
                                                                          "name"],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: color
                                                                      .green(),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          const SizedBox(
                                                              width: 5),
                                                          const Icon(Icons.lock,
                                                              color:
                                                                  Colors.black,
                                                              size: 10),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.sp),
                                                      SizedBox(width: 40.sp),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              height: 10.sp),
                                                          SvgPicture.asset(
                                                            "assets/images/svg/target.svg",
                                                            height: 13.h,
                                                            color:
                                                                color.green(),
                                                            width: 13.w,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                          SizedBox(width: 10.w),
                                                          Text(
                                                              "₦" +
                                                                  allSavingsPlans![
                                                                              index]
                                                                          [
                                                                          "target"]
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          SizedBox(width: 5.sp),
                                                          Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              color:
                                                                  Colors.black,
                                                              size: 10.sp),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Text(
                                                          percentageCrushed
                                                                  .toString() +
                                                              "% Achieved",
                                                          style: TextStyle(
                                                              fontSize: 7.sp,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width: 23.sp),
                                                          GestureDetector(
                                                              onTap: (() => Get.to(Deposit(
                                                                  savingsID:
                                                                      allSavingsPlans?[index]
                                                                          [
                                                                          "id"],
                                                                  savingsName:
                                                                      allSavingsPlans?[index]
                                                                          [
                                                                          "name"],
                                                                  target: allSavingsPlans?[
                                                                          index]
                                                                      [
                                                                      "target"],
                                                                  totalSaved: allSavingsPlans?[
                                                                          index]
                                                                      ["total_saved"]))),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .circlePlus,
                                                                color: color
                                                                    .green(),
                                                                size: 15.sp,
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.sp),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width: 14.sp),
                                                          Column(
                                                            children: [
                                                              Text("Interest",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          7.sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                              Text("₦0.00",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          9.sp,
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
                                                padding: EdgeInsets.only(
                                                    left: 14.sp,
                                                    right: 14.sp,
                                                    top: 7.sp,
                                                    bottom: 7.sp),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.sp),
                                                    color: Colors.grey
                                                        .withOpacity(0.1)),
                                              );
                                            }))
                                    //This second container has a shorter height

                                    : const SizedBox(),

                                extend == true
                                    ? SizedBox(height: 5.sp)
                                    : SizedBox(height: 4.sp),

                                (allSavingsPlans!.isEmpty)
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
                                                          fontSize: 10.sp,
                                                          color: color.green(),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.lock,
                                                      color: Colors.black,
                                                      size: 10.sp),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              SizedBox(width: 40.w),
                                              Row(
                                                children: [
                                                  SizedBox(height: 10.h),
                                                  SvgPicture.asset(
                                                    "assets/images/svg/target.svg",
                                                    height: 13,
                                                    color: color.green(),
                                                    width: 13.sp,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text("₦0.00",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.visibility_off,
                                                      color: Colors.black,
                                                      size: 10),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text("0% Achieved",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
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
                                              Row(children: [
                                                SizedBox(width: 14.sp),
                                                GestureDetector(
                                                    onTap: (() =>
                                                        Get.to(const SetSavings(
                                                          defaultSavingsName:
                                                              "business-default",
                                                        ))),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .circlePlus,
                                                      color: color.green(),
                                                      size: 15.sp,
                                                    ))
                                              ]),
                                              const SizedBox(height: 10),
                                              Column(children: [
                                                SizedBox(width: 14.sp),
                                                const Text("Interest",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 7.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ])
                                            ],
                                          )
                                        ]),
                                        width: double.maxFinite,
                                        padding: EdgeInsets.only(
                                            left: 10.sp,
                                            right: 10.sp,
                                            top: 7.sp,
                                            bottom: 7.sp),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.sp),
                                            color:
                                                Colors.grey.withOpacity(0.1)),
                                      )
                                    : const SizedBox(),
                                extend == true
                                    ? SizedBox(height: 5.sp)
                                    : SizedBox(height: 5.sp),

                                (allSavingsPlans!.isEmpty)
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
                                                          fontSize: 10.sp,
                                                          color: color.green(),
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.lock,
                                                      color: Colors.black,
                                                      size: 10.sp),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              SizedBox(width: 40.w),
                                              Row(
                                                children: [
                                                  SizedBox(height: 10.h),
                                                  SvgPicture.asset(
                                                    "assets/images/svg/target.svg",
                                                    height: 12.sp,
                                                    color: color.green(),
                                                    width: 12.sp,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text("₦0.00",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.visibility_off,
                                                      color: Colors.black,
                                                      size: 10.sp),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text("0% Achieved",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
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
                                              Row(children: [
                                                SizedBox(width: 14.sp),
                                                GestureDetector(
                                                    onTap: (() =>
                                                        Get.to(const SetSavings(
                                                          defaultSavingsName:
                                                              "rent-default",
                                                        ))),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .circlePlus,
                                                      color: color.green(),
                                                      size: 15.sp,
                                                    ))
                                              ]),
                                              const SizedBox(height: 10),
                                              Column(children: [
                                                SizedBox(width: 14.w),
                                                Text("Interest",
                                                    style: TextStyle(
                                                        fontSize: 9.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 7.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ])
                                            ],
                                          )
                                        ]),
                                        width: double.maxFinite,
                                        padding: EdgeInsets.only(
                                            left: 10.sp,
                                            right: 10.sp,
                                            top: 10.sp,
                                            bottom: 10.sp),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.sp),
                                            color:
                                                Colors.grey.withOpacity(0.1)),
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
                                      height: 18.sp,
                                      color: color.green(),
                                      width: 18.sp,
                                      fit: BoxFit.scaleDown,
                                    ))),
                                const SizedBox(height: 1),

                                Container(
                                    height: Get.height < 1300 ? 335.sp : 355.sp,
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: FutureBuilder(
                                        future: Others().getProducts(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return loader();
                                          } else {
                                            if (snapshot.data.isNotEmpty &&
                                                snapshot.data != null) {
                                              List? products = snapshot.data;
                                              return ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: products!.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                separatorBuilder: (c, i) {
                                                  return SizedBox(width: 10.sp);
                                                },
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                      width: Get.width - 50,
                                                      // height: 120,
                                                      color: Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.sp),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: "https://statup.ng/statup/" +
                                                                  products[
                                                                          index]
                                                                      ["image"],
                                                              width: Get.width,
                                                              fit: BoxFit.cover,
                                                              height:
                                                                  Get.height <
                                                                          1100
                                                                      ? 248.sp
                                                                      : 270.sp,
                                                              placeholder:
                                                                  (ctx, text) {
                                                                return loader();
                                                              },
                                                            ),
                                                          )),
                                                          SizedBox(
                                                              height: 2.sp),
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
                                                                      products[index]
                                                                          [
                                                                          "product_name"],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize: 15
                                                                              .sp,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  SizedBox(
                                                                      height:
                                                                          2.sp),
                                                                  Text(
                                                                      products[index]
                                                                          [
                                                                          "product_desc"],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize: 8
                                                                              .sp,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal)),
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
                                                                          fontSize: 15
                                                                              .sp,
                                                                          color: color
                                                                              .green(),
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Sold",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              fontSize: 11.sp,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      SizedBox(
                                                                          width:
                                                                              5.w),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.sp),
                                                                            border: Border.all(color: Color.fromARGB(255, 207, 207, 207))),
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                10.sp,
                                                                            right: 10.sp,
                                                                            top: 3.sp,
                                                                            bottom: 3.sp),
                                                                        child: Text(
                                                                            products[index][
                                                                                "sold"],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                              fontSize: 11.sp,
                                                                              color: Colors.black,
                                                                            )),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: 2.sp),
                                                          GestureDetector(
                                                              onTap: (() {
                                                                _buy(context);
                                                              }),
                                                              child: Material(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25.0),
                                                                  elevation:
                                                                      10.sp,
                                                                  shadowColor: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          209,
                                                                          209,
                                                                          209),
                                                                  child: Container(
                                                                      height: Get.height > 1300 ? 44.sp : 30.sp,
                                                                      width: double.maxFinite,
                                                                      decoration: BoxDecoration(
                                                                        color: color
                                                                            .orange(),
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              25.0),
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                            "Buy",
                                                                            style: TextStyle(
                                                                                fontSize: 12.sp,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold)),
                                                                      )
                                                                      //rest of the existing code
                                                                      )))
                                                        ],
                                                      ));
                                                },
                                              );
                                            } else {
                                              return Container(
                                                  child: const Center(
                                                child: Text(
                                                    "Could Not Retrieve Products"),
                                              ));
                                            }
                                          }
                                        }))
                              ],
                            ),
                          ),
                        )
                      : //disabled scrolling

                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 3.h),
                              Center(
                                  child: Column(
                                children: [
                                  Text("Overall Target",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 9.sp, color: Colors.black)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          overallTargetVisibility == true
                                              ? "₦" + overallTarget.toString()
                                              : "--+--",
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      SizedBox(width: 5.w),
                                      GestureDetector(
                                          onTap: () => {
                                                setState(() {
                                                  overallTargetVisibility =
                                                      !overallTargetVisibility;
                                                })
                                              },
                                          child: Icon(Icons.visibility_off,
                                              size: 13.sp, color: Colors.black))
                                    ],
                                  ),
                                ],
                              )),

                              SizedBox(height: 5.h),
                              //
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        20,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.only(
                                            top: 22.sp,
                                            bottom: 22.sp,
                                            left: 10.sp,
                                            right: 10.sp),
                                        decoration: BoxDecoration(
                                          color: color.green(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24.sp)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
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
                                            children: [
                                              Text("Crushed Goals",
                                                  style: TextStyle(
                                                      fontSize: 6.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "₦" +
                                                      overallSavings.toString(),
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              36,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              top: 20.sp, bottom: 20.sp),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(24.sp)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.6),
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
                                                        _showMaterialDialog(
                                                            context)
                                                      }),
                                                  child: Container(
                                                    child: Center(
                                                        child: Text("StaQ",
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    padding:
                                                        EdgeInsets.all(5.sp),
                                                  )))))
                                ],
                              ),
                              SizedBox(height: 5.h),
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
                                          primary: false,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          separatorBuilder: (c, i) {
                                            return SizedBox(
                                              height: 5.sp,
                                            );
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String totalSaved =
                                                allSavingsPlans![index]
                                                    ["total_saved"];

                                            String target =
                                                allSavingsPlans![index]
                                                    ["target"];

                                            int percentageCrushed =
                                                percentageAchieved(
                                                    int.parse(totalSaved),
                                                    int.parse(target));

                                            return Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
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
                                                            allSavingsPlans![
                                                                            index]
                                                                        [
                                                                        "name"] ==
                                                                    "business-default"
                                                                ? "Business"
                                                                : ["name"] ==
                                                                        "rent-default"
                                                                    ? "Rent"
                                                                    : allSavingsPlans![
                                                                            index]
                                                                        [
                                                                        "name"],
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: color
                                                                    .green(),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Icon(Icons.lock,
                                                            color: Colors.black,
                                                            size: 10),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.sp),
                                                    SizedBox(width: 40.sp),
                                                    Row(
                                                      children: [
                                                        SizedBox(height: 10.sp),
                                                        SvgPicture.asset(
                                                          "assets/images/svg/target.svg",
                                                          height: 13.h,
                                                          color: color.green(),
                                                          width: 13.w,
                                                          fit: BoxFit.scaleDown,
                                                        ),
                                                        SizedBox(width: 10.w),
                                                        Text(
                                                            "₦" +
                                                                allSavingsPlans![
                                                                            index]
                                                                        [
                                                                        "target"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(width: 5.sp),
                                                        Icon(
                                                            Icons
                                                                .visibility_off,
                                                            color: Colors.black,
                                                            size: 10.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                        percentageCrushed
                                                                .toString() +
                                                            "% Achieved",
                                                        style: TextStyle(
                                                            fontSize: 7.sp,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
                                                        SizedBox(width: 23.sp),
                                                        GestureDetector(
                                                            onTap: (() => Get.to(Deposit(
                                                                savingsID:
                                                                    allSavingsPlans?[index]
                                                                        ["id"],
                                                                savingsName:
                                                                    allSavingsPlans?[
                                                                            index][
                                                                        "name"],
                                                                target: allSavingsPlans?[
                                                                        index]
                                                                    ["target"],
                                                                totalSaved:
                                                                    allSavingsPlans?[
                                                                            index]
                                                                        ["total_saved"]))),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .circlePlus,
                                                              color:
                                                                  color.green(),
                                                              size: 15.sp,
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.sp),
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 14.sp),
                                                        Column(
                                                          children: [
                                                            Text("Interest",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        7.sp,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                            Text("₦0.00",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        9.sp,
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
                                              padding: EdgeInsets.only(
                                                  left: 14.sp,
                                                  right: 14.sp,
                                                  top: 7.sp,
                                                  bottom: 7.sp),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.sp),
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                            );
                                          }))
                                  //This second container has a shorter height

                                  : const SizedBox(),

                              extend == true
                                  ? SizedBox(height: 5.sp)
                                  : SizedBox(height: 4.sp),

                              (allSavingsPlans!.isEmpty)
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
                                                        fontSize: 10.sp,
                                                        color: color.green(),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.lock,
                                                    color: Colors.black,
                                                    size: 10.sp),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            SizedBox(width: 40.w),
                                            Row(
                                              children: [
                                                SizedBox(height: 10.h),
                                                SvgPicture.asset(
                                                  "assets/images/svg/target.svg",
                                                  height: 13,
                                                  color: color.green(),
                                                  width: 13.sp,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                SizedBox(width: 10.w),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.visibility_off,
                                                    color: Colors.black,
                                                    size: 10),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text("0% Achieved",
                                                style: TextStyle(
                                                    fontSize: 7.sp,
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
                                            Row(children: [
                                              SizedBox(width: 14.sp),
                                              GestureDetector(
                                                  onTap: (() =>
                                                      Get.to(const SetSavings(
                                                        defaultSavingsName:
                                                            "business-default",
                                                      ))),
                                                  child: Icon(
                                                    FontAwesomeIcons.circlePlus,
                                                    color: color.green(),
                                                    size: 15.sp,
                                                  ))
                                            ]),
                                            const SizedBox(height: 10),
                                            Column(children: [
                                              SizedBox(width: 14.sp),
                                              const Text("Interest",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Text("₦0.00",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ])
                                          ],
                                        )
                                      ]),
                                      width: double.maxFinite,
                                      padding: EdgeInsets.only(
                                          left: 10.sp,
                                          right: 10.sp,
                                          top: 7.sp,
                                          bottom: 7.sp),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.sp),
                                          color: Colors.grey.withOpacity(0.1)),
                                    )
                                  : const SizedBox(),
                              extend == true
                                  ? SizedBox(height: 5.sp)
                                  : SizedBox(),

                              (allSavingsPlans!.isEmpty)
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
                                                        fontSize: 10.sp,
                                                        color: color.green(),
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.lock,
                                                    color: Colors.black,
                                                    size: 10.sp),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            SizedBox(width: 40.w),
                                            Row(
                                              children: [
                                                SizedBox(height: 10.h),
                                                SvgPicture.asset(
                                                  "assets/images/svg/target.svg",
                                                  height: 12.sp,
                                                  color: color.green(),
                                                  width: 12.sp,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                const SizedBox(width: 10),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.visibility_off,
                                                    color: Colors.black,
                                                    size: 10.sp),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text("0% Achieved",
                                                style: TextStyle(
                                                    fontSize: 7.sp,
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
                                            Row(children: [
                                              SizedBox(width: 14.sp),
                                              GestureDetector(
                                                  onTap: (() =>
                                                      Get.to(const SetSavings(
                                                        defaultSavingsName:
                                                            "rent-default",
                                                      ))),
                                                  child: Icon(
                                                    FontAwesomeIcons.circlePlus,
                                                    color: color.green(),
                                                    size: 15.sp,
                                                  ))
                                            ]),
                                            const SizedBox(height: 10),
                                            Column(children: [
                                              SizedBox(width: 14.w),
                                              Text("Interest",
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Text("₦0.00",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ])
                                          ],
                                        )
                                      ]),
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(top: 8),
                                      padding: EdgeInsets.only(
                                          left: 10.sp,
                                          right: 10.sp,
                                          top: 10.sp,
                                          bottom: 10.sp),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.sp),
                                          color: Colors.grey.withOpacity(0.1)),
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
                                    height: 18.sp,
                                    color: color.green(),
                                    width: 18.sp,
                                    fit: BoxFit.scaleDown,
                                  ))),
                              const SizedBox(height: 1),

                              Expanded(
                                  child: Container(
                                      color: Colors.white,
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(bottom: 0),
                                      child: FutureBuilder(
                                          future: Others().getProducts(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (!snapshot.hasData) {
                                              return loader();
                                            } else {
                                              if (snapshot.data.isNotEmpty &&
                                                  snapshot.data != null) {
                                                List? products = snapshot.data;
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: products!.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  primary: false,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  separatorBuilder: (c, i) {
                                                    return SizedBox(
                                                        width: 10.sp);
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                        width: Get.width - 50,
                                                        // height: 120,
                                                        color: Colors.white,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.sp),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: "https://statup.ng/statup/" +
                                                                    products[
                                                                            index]
                                                                        [
                                                                        "image"],
                                                                width:
                                                                    Get.width,
                                                                fit: BoxFit
                                                                    .cover,
                                                                height:
                                                                    Get.height <
                                                                            1100
                                                                        ? 248.sp
                                                                        : 270
                                                                            .sp,
                                                                placeholder:
                                                                    (ctx,
                                                                        text) {
                                                                  return loader();
                                                                },
                                                              ),
                                                            )),
                                                            SizedBox(
                                                                height: 2.sp),
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
                                                                        products[index]
                                                                            [
                                                                            "product_name"],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                    SizedBox(
                                                                        height:
                                                                            2.sp),
                                                                    Text(
                                                                        products[index]
                                                                            [
                                                                            "product_desc"],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                8.sp,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.normal)),
                                                                  ],
                                                                ),
                                                                Spacer(),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                        "₦" +
                                                                            products[index][
                                                                                "product_price"],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: color.green(),
                                                                            fontWeight: FontWeight.bold)),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Sold",
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontSize: 11.sp,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        SizedBox(
                                                                            width:
                                                                                5.w),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(6.sp),
                                                                              border: Border.all(color: Color.fromARGB(255, 207, 207, 207))),
                                                                          padding: EdgeInsets.only(
                                                                              left: 10.sp,
                                                                              right: 10.sp,
                                                                              top: 3.sp,
                                                                              bottom: 3.sp),
                                                                          child: Text(
                                                                              products[index]["sold"],
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 11.sp,
                                                                                color: Colors.black,
                                                                              )),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 2.sp),
                                                            GestureDetector(
                                                                onTap: (() {
                                                                  _buy(context);
                                                                }),
                                                                child: Material(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    elevation:
                                                                        10.sp,
                                                                    shadowColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            209,
                                                                            209,
                                                                            209),
                                                                    child: Container(
                                                                        height: Get.height > 1300 ? 44.sp : 30.sp,
                                                                        width: double.maxFinite,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              color.orange(),
                                                                          borderRadius:
                                                                              const BorderRadius.all(
                                                                            Radius.circular(25.0),
                                                                          ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                              "Buy",
                                                                              style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                                                                        )
                                                                        //rest of the existing code
                                                                        )))
                                                          ],
                                                        ));
                                                  },
                                                );
                                              } else {
                                                return Container(
                                                    child: const Center(
                                                  child: Text(
                                                      "Could Not Retrieve Products"),
                                                ));
                                              }
                                            }
                                          }))),
                            ],
                          ),
                        )))),
          Visibility(
              visible: updateNotif,
              child: Material(
                  color: Colors.black.withOpacity(.2),
                  child: Container(
                      // <-- Add this, if needed Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                          child: SizedBox(
                              height: 300.sp,
                              child: Column(children: [
                                Text(
                                    'Hello, this app has a new update. Please update to the latest version to enjoy the best experience.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 20.sp),
                                GestureDetector(
                                    onTap: (() {
                                      if (Platform.isIOS) {
                                        platform = 'iOS';
                                        launchAppstore(
                                            "https://play.google.com/store/apps/details?id=com.statup.app");
                                      } else {
                                        platform = 'Android';
                                        launchPlaystore(
                                            "https://play.google.com/store/apps/details?id=com.statup.app");
                                      }
                                    }),
                                    child: Material(
                                        borderRadius:
                                            BorderRadius.circular(25.0.sp),
                                        elevation: 10,
                                        shadowColor:
                                            Color.fromARGB(255, 209, 209, 209),
                                        child: Container(
                                            height: 35.sp,
                                            width: 100.sp,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25.0.sp),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text("Update",
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                            //rest of the existing code
                                            )))
                              ])))))),
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
                child: Center(
                    child: Text("Coming Soon",
                        style: TextStyle(
                            fontSize: 25.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)))),
          ),
        ),
      ),
    );
  }

  void _buy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
          child: Material(
              color: Colors.black.withOpacity(.2),
              child: Center(
                child: Container(
                    margin: EdgeInsets.all(20.sp),
                    width: double.maxFinite,
                    height: 360.sp,
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.sp),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: (() => {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                  }),
                              child: Icon(Icons.close, size: 20.sp),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("You are about to make a purchase",
                            style: TextStyle(fontSize: 20.sp)),
                        SizedBox(height: 20),
                        SizedBox(
                          child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              dropdownButtonSplashRadius: 20,
                              // showSelectedItem: true,
                              items: states.getStates(),
                              label: "Select State",
                              hint: state,
                              popupItemDisabled: (String s) =>
                                  s.startsWith('I'),
                              onChanged: (data) {
                                setState(() {
                                  state = data.toString();
                                  print("davido + states");
                                });
                              },
                              selectedItem: state),
                        ),
                        SizedBox(height: 20.sp),
                        CustomField4(
                          hint: "Contact Phone Number",
                          controller: _phoneController,
                        ),
                        SizedBox(height: 10.sp),
                        CustomField4(
                          hint: "Contact Address",
                          controller: _phoneController,
                        ),
                        SizedBox(height: 10.sp),
                        GestureDetector(
                            onTap: (() {
                              Get.to(Purchase());
                            }),
                            child: Material(
                                borderRadius: BorderRadius.circular(25.0.sp),
                                elevation: 10,
                                shadowColor: Color.fromARGB(255, 209, 209, 209),
                                child: Container(
                                    height: 40.sp,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: color.orange(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Center(
                                      child: const Text("Make Purchase",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )
                                    //rest of the existing code
                                    )))
                      ],
                    )),
              ))),
    );
  }

  void _showMaterialDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
                width: 250,
                height: 250,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Center(
                    child: Text(
                        "You're using an old version of the app\nPlease update to the latest version",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)))),
          ),
        ),
      ),
    );
  }

  Future<void> launchPlaystore(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      print("could not launch link");
      throw 'Could not launch telegram url';
    } else {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchAppstore(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      print("could not launch link");
      throw 'Could not launch telegram url';
    } else {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    int androidVersion = int.parse(Hive.box("statup").get("android_version"));

    int iosVersion = int.parse(Hive.box("statup").get("ios_version"));

    int version = int.parse(packageInfo.version);
    int buildNumber = int.parse(packageInfo.buildNumber);

    if (Platform.isIOS) {
      platform = 'iOS';
      if (buildNumber > iosVersion) {
        setState(() {
          updateNotif = true;
        });
      }
    } else {
      if (version > androidVersion) {
        setState(() {
          updateNotif = true;
        });
      }
      platform = 'Android';
    }
  }
}
