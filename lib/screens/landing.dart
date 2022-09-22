// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth.dart';
import '/screens/add_business.dart';
import '/screens/customise_savings.dart';
import '/screens/explore.dart';
import '/screens/profile.dart';
import '/screens/set_savings.dart';
import '/screens/transactions.dart' as eom;
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:monnify_payment_sdk/application_mode.dart';
// import 'package:monnify_payment_sdk/payment_method.dart';
// import 'package:monnify_payment_sdk/transaction.dart';
// import 'package:monnify_payment_sdk/transaction_response.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jiffy/jiffy.dart';

class Landing extends StatefulWidget {
  final notif_count;
  final prev;
  const Landing({Key? key, this.notif_count, this.prev})
      : super(
          key: key,
        );

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
  bool crushedTargetVisibility = false;
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
  TextEditingController _addressController = TextEditingController();
  String state = "Select State";

  String? statup_corp_bank = Hive.box("statup").get("statup_corp_bank");
  String? statup_corp_name = Hive.box("statup").get("statup_corp_name");
  String? statup_corp_num = Hive.box("statup").get("statup_corp_num");
  String firstName = Hive.box("statup").get("first_name");
  String last = Hive.box("statup").get("last_name");
  String email = Hive.box("statup").get("email");
  int? unread_notifs = 0;
  // final _monnifyPaymentSdkPlugin = MonnifyPaymentSdk();
  late Monnify? _monnifyPaymentSdkPlugin;

  String selected_prod_price = "";
  String selected_prod_id = "";
  String selected_prod_name = "";

  @override
  initState() {
    super.initState();

    initializeSdk();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'Orders Notifications', // title

        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
        showBadge: true);

    void handleMessage(RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: const IOSNotificationDetails(
              sound: 'default',
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              enableVibration: true,
              playSound: true,
              icon: 'launcher_icon',
            ),
          ),
        );
      }
    }

    try {
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {});

      FirebaseMessaging.instance.getToken().then((value) =>
          {AuthService().setFCMToken(fcm_token: value), print("fcmtoken  $value")});

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        setState(() {
          if (message.data["notif_type"].toString() == "credit") {
            overallSavings = int.parse(message.data["amount"].toString());
          }
        });
        handleMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // handleMessage(message);
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
        AuthService().setFCMToken(fcm_token: token);
        print("fcmtoken " + token);
        // sync token to server
      });
    } catch (e) {
      print("No internet connection");
    }

    Timer(const Duration(seconds: 2), () {
      // _showMaterialDialog2(context);
      /*setState(() {
        welcomeGIFVisible = false;
      });*/
    });

    getAppInfo();

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

        overallTarget = overallTarget + int.parse(allSavingsPlans![i]["target"]);
        overallSavings = overallSavings + int.parse(allSavingsPlans![i]["total_saved"]);
      }
    } else {
      allSavingsPlans = [];
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) < const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back to exit app", gravity: ToastGravity.TOP);
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
        Get.to(eom.Transaction());
      } else if (index == 3) {
        Get.to(Explore());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prev == "notif" && widget.notif_count != null) {
      setState(() {
        unread_notifs = widget.notif_count;
      });
    } else {
      setState(() {
        unread_notifs = Hive.box("statup").get("unread-notifs");
      });
    }
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
                                              child: Stack(children: [
                                            SvgPicture.asset(
                                              "assets/images/svg/notification-svgrepo-com.svg",
                                              height: 23.h,
                                              width: 23.w,
                                              fit: BoxFit.scaleDown,
                                            ),
                                            unread_notifs.toString() == "null" ||
                                                    unread_notifs.toString() == "0"
                                                ? SizedBox()
                                                : Positioned(
                                                    left: 6,
                                                    bottom: 8,
                                                    child: Container(
                                                      width: 15,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        color: color.orange(),
                                                        borderRadius:
                                                            BorderRadius.circular(50),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          unread_notifs.toString() ==
                                                                  "null"
                                                              ? "0"
                                                              : unread_notifs.toString(),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                          ]))),
                                      SizedBox(width: 20.w),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(const Profile());
                                        },

                                        child: cachedProfileImg.toString() != "" &&
                                                cachedProfileImg.toString() != "null"
                                            ? Container(
                                                decoration:
                                                    BoxDecoration(shape: BoxShape.circle),
                                                child: Image.network(
                                                    "https://statup.ng/statup/" +
                                                        cachedProfileImg.toString(),
                                                    height: 14.h,
                                                    width: 14.w))
                                            : Icon(Icons.account_circle,
                                                color: Colors.black, size: 22.sp),

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
                                /* Center(
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
                                ))*/

                                SizedBox(height: 5.h),
                                //
                                Row(
                                  children: [
                                    SizedBox(
                                      width: (MediaQuery.of(context).size.width / 2) - 20,
                                      child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          padding: EdgeInsets.only(
                                              top: 22.sp,
                                              bottom: 22.sp,
                                              left: 10.sp,
                                              right: 10.sp),
                                          decoration: BoxDecoration(
                                            color: color.green(),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(24.sp)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.6),
                                                spreadRadius: 3,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            width: double.maxFinite,
                                            child: Column(
                                              children: [
                                                Text("Crushed Goals",
                                                    style: TextStyle(
                                                        fontSize: 8.sp,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(height: 2.sp),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        crushedTargetVisibility == true
                                                            ? "₦" +
                                                                overallSavings.toString()
                                                            : "--",
                                                        style: TextStyle(
                                                            fontSize: 11.sp,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold)),
                                                    SizedBox(width: 5.sp),
                                                    GestureDetector(
                                                        onTap: () => {
                                                              setState(() {
                                                                crushedTargetVisibility =
                                                                    !crushedTargetVisibility;
                                                              })
                                                            },
                                                        child: Icon(
                                                            crushedTargetVisibility ==
                                                                    false
                                                                ? Icons.visibility_off
                                                                : Icons.visibility,
                                                            size: 12.sp,
                                                            color: Color.fromARGB(
                                                                255, 255, 255, 255)))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width / 2) - 36,
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20.sp, bottom: 20.sp),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24.sp)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  spreadRadius: 3,
                                                  blurRadius: 4,
                                                  offset: Offset(
                                                      0, 2), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: GestureDetector(
                                                onTap: (() => Get.to(
                                                      const OnboardingOne(),
                                                    )),
                                                child: GestureDetector(
                                                    onTap: (() =>
                                                        {_showMaterialDialog(context)}),
                                                    child: Container(
                                                      child: Center(
                                                          child: Text("StaQ",
                                                              style: TextStyle(
                                                                  fontSize: 12.sp,
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight.bold))),
                                                      padding: EdgeInsets.all(5.sp),
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
                                            physics: const BouncingScrollPhysics(),
                                            separatorBuilder: (c, i) {
                                              return SizedBox(
                                                height: 5.sp,
                                              );
                                            },
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              String totalSaved =
                                                  allSavingsPlans![index]["total_saved"];

                                              String target =
                                                  allSavingsPlans![index]["target"];

                                              int percentageCrushed = percentageAchieved(
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
                                                              setSavingsPlansFeName(
                                                                  allSavingsPlans![index]
                                                                      ["name"]),
                                                              style: TextStyle(
                                                                  fontSize: 10.sp,
                                                                  color: color.green(),
                                                                  fontWeight:
                                                                      FontWeight.bold)),
                                                          const SizedBox(width: 5),
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
                                                                  allSavingsPlans![index]
                                                                          ["total_saved"]
                                                                      .toString(),
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
                                                      SizedBox(height: 5.h),
                                                      Text(
                                                          allSavingsPlans![index]
                                                                      ["type"] ==
                                                                  "DURATION"
                                                              ? "Ending: " +
                                                                  calculateTimeLeft(
                                                                      allSavingsPlans![
                                                                              index]
                                                                          ["created_at"],
                                                                      allSavingsPlans![
                                                                              index]
                                                                          ["duration"])
                                                              : percentageCrushed
                                                                      .toString() +
                                                                  "% Achieved",
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
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 23.sp),
                                                          GestureDetector(
                                                              onTap: (() => Get.to(Deposit(
                                                                  savingsID:
                                                                      allSavingsPlans?[
                                                                          index]["id"],
                                                                  savingsName:
                                                                      allSavingsPlans?[
                                                                          index]["name"],
                                                                  target: allSavingsPlans?[
                                                                      index]["target"],
                                                                  interest:
                                                                      allSavingsPlans?[index]
                                                                          ["interest"],
                                                                  totalSaved:
                                                                      allSavingsPlans?[index]
                                                                          ["total_saved"]))),
                                                              child: Icon(
                                                                FontAwesomeIcons
                                                                    .circlePlus,
                                                                color: color.green(),
                                                                size: 17.sp,
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
                                                                      fontSize: 7.sp,
                                                                      color: Colors.black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal)),
                                                              Text(
                                                                  allSavingsPlans?[index][
                                                                              "interest"] ==
                                                                          "0"
                                                                      ? "₦"
                                                                          "0.00"
                                                                      : "₦" +
                                                                          allSavingsPlans?[
                                                                                  index][
                                                                              "interest"],
                                                                  style: TextStyle(
                                                                      fontSize: 9.sp,
                                                                      color: Colors.black,
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
                                                        BorderRadius.circular(18.sp),
                                                    color: Colors.grey.withOpacity(0.1)),
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Business",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: color.green(),
                                                          fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.lock,
                                                      color: Colors.black, size: 10.sp),
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
                                                          fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.visibility_off,
                                                      color: Colors.black, size: 10),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text("Not Active",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                SizedBox(width: 14.sp),
                                                GestureDetector(
                                                    onTap: (() => Get.to(const SetSavings(
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
                                                        fontWeight: FontWeight.normal)),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 7.sp,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold)),
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
                                            borderRadius: BorderRadius.circular(18.sp),
                                            color: Colors.grey.withOpacity(0.1)),
                                      )
                                    : const SizedBox(),
                                extend == true
                                    ? SizedBox(height: 5.sp)
                                    : SizedBox(height: 5.sp),

                                (allSavingsPlans!.isEmpty)
                                    ? Container(
                                        child: Row(children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Rent",
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: color.green(),
                                                          fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.lock,
                                                      color: Colors.black, size: 10.sp),
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
                                                          fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  Icon(Icons.visibility_off,
                                                      color: Colors.black, size: 10.sp),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text("Not Active",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                SizedBox(width: 14.sp),
                                                GestureDetector(
                                                    onTap: (() => Get.to(const SetSavings(
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
                                                        fontWeight: FontWeight.normal)),
                                                Text("₦0.00",
                                                    style: TextStyle(
                                                        fontSize: 7.sp,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold)),
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
                                            borderRadius: BorderRadius.circular(18.sp),
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

                                Container(
                                    height: Get.height < 1300 ? 335.sp : 355.sp,
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: FutureBuilder(
                                        future: Others().getProducts(),
                                        builder: (context, AsyncSnapshot snapshot) {
                                          if (!snapshot.hasData) {
                                            return loader();
                                          } else {
                                            if (snapshot.data.isNotEmpty &&
                                                snapshot.data != null) {
                                              List? products = snapshot.data;
                                              return ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: products!.length,
                                                scrollDirection: Axis.horizontal,
                                                physics: const BouncingScrollPhysics(),
                                                separatorBuilder: (c, i) {
                                                  return SizedBox(width: 10.sp);
                                                },
                                                itemBuilder:
                                                    (BuildContext context, int index) {
                                                  return Container(
                                                      width: Get.width - 50,
                                                      // height: 120,
                                                      color: Colors.white,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                              child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    25.sp),
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                                  "https://statup.ng/statup/" +
                                                                      products[index]
                                                                          ["image"],
                                                              width: Get.width,
                                                              fit: BoxFit.cover,
                                                              height: Get.height < 1100
                                                                  ? 248.sp
                                                                  : 270.sp,
                                                              placeholder: (ctx, text) {
                                                                return loader();
                                                              },
                                                            ),
                                                          )),
                                                          SizedBox(height: 2.sp),
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
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize: 15.sp,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold)),
                                                                  SizedBox(height: 2.sp),
                                                                  Text(
                                                                      products[index][
                                                                          "product_desc"],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize: 8.sp,
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
                                                                          products[index][
                                                                              "product_price"],
                                                                      textAlign: TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize: 15.sp,
                                                                          color: color
                                                                              .green(),
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold)),
                                                                  Row(
                                                                    children: [
                                                                      Text("Sold",
                                                                          textAlign:
                                                                              TextAlign
                                                                                  .center,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                                  11.sp,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold)),
                                                                      SizedBox(
                                                                          width: 5.w),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(6
                                                                                        .sp),
                                                                            border: Border.all(
                                                                                color: Color.fromARGB(
                                                                                    255,
                                                                                    207,
                                                                                    207,
                                                                                    207))),
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                                left:
                                                                                    10.sp,
                                                                                right:
                                                                                    10.sp,
                                                                                top: 3.sp,
                                                                                bottom:
                                                                                    3.sp),
                                                                        child: Text(
                                                                            products[
                                                                                    index]
                                                                                ["sold"],
                                                                            textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize:
                                                                                  11.sp,
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
                                                          SizedBox(height: 2.sp),
                                                          GestureDetector(
                                                              onTap: (() {
                                                                setState(() {
                                                                  selected_prod_id =
                                                                      products[index]
                                                                          ["id"];

                                                                  selected_prod_price =
                                                                      products[index][
                                                                          "product_price"];

                                                                  selected_prod_name =
                                                                      products[index][
                                                                          "product_name"];
                                                                });

                                                                _buy(context);
                                                              }),
                                                              child: Material(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(25.0),
                                                                  elevation: 10.sp,
                                                                  shadowColor:
                                                                      Color.fromARGB(255,
                                                                          209, 209, 209),
                                                                  child: Container(
                                                                      height: Get.height >
                                                                              1300
                                                                          ? 44.sp
                                                                          : 30.sp,
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
                                                                        child: Text("Buy",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    12.sp,
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .bold)),
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
                                                child:
                                                    Text("Could Not Retrieve Products"),
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
                              /*Center(
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
                              )),*/

                              SizedBox(height: 5.h),
                              //
                              Row(
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width / 2) - 20,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        padding: EdgeInsets.only(
                                            top: 22.sp,
                                            bottom: 22.sp,
                                            left: 10.sp,
                                            right: 10.sp),
                                        decoration: BoxDecoration(
                                          color: color.green(),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(24.sp)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.6),
                                              spreadRadius: 3,
                                              blurRadius: 4,
                                              offset: Offset(
                                                  0, 2), // changes position of shadow
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
                                                      fontWeight: FontWeight.bold)),
                                              SizedBox(height: 2.sp),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      crushedTargetVisibility == true
                                                          ? "₦" +
                                                              overallSavings.toString()
                                                          : "--",
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold)),
                                                  SizedBox(width: 5.sp),
                                                  GestureDetector(
                                                      onTap: () => {
                                                            setState(() {
                                                              crushedTargetVisibility =
                                                                  !crushedTargetVisibility;
                                                            })
                                                          },
                                                      child: Icon(
                                                          crushedTargetVisibility == false
                                                              ? Icons.visibility_off
                                                              : Icons.visibility,
                                                          size: 12.sp,
                                                          color: Color.fromARGB(
                                                              255, 255, 255, 255)))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: (MediaQuery.of(context).size.width / 2) - 36,
                                      child: Container(
                                          padding:
                                              EdgeInsets.only(top: 20.sp, bottom: 20.sp),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(24.sp)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.6),
                                                spreadRadius: 3,
                                                blurRadius: 4,
                                                offset: Offset(
                                                    0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                              onTap: (() => Get.to(
                                                    const OnboardingOne(),
                                                  )),
                                              child: GestureDetector(
                                                  onTap: (() =>
                                                      {_showMaterialDialog(context)}),
                                                  child: Container(
                                                    child: Center(
                                                        child: Text("StaQ",
                                                            style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors.white,
                                                                fontWeight:
                                                                    FontWeight.bold))),
                                                    padding: EdgeInsets.all(5.sp),
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
                                          physics: const NeverScrollableScrollPhysics(),
                                          separatorBuilder: (c, i) {
                                            return SizedBox(
                                              height: 5.sp,
                                            );
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            String totalSaved =
                                                allSavingsPlans![index]["total_saved"];

                                            String target =
                                                allSavingsPlans![index]["target"];

                                            int percentageCrushed = percentageAchieved(
                                                int.parse(totalSaved), int.parse(target));

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
                                                            setSavingsPlansFeName(
                                                                allSavingsPlans![index]
                                                                    ["name"]),
                                                            style: TextStyle(
                                                                fontSize: 10.sp,
                                                                color: color.green(),
                                                                fontWeight:
                                                                    FontWeight.bold)),
                                                        const SizedBox(width: 5),
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
                                                                allSavingsPlans![index]
                                                                        ["total_saved"]
                                                                    .toString(),
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
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                        allSavingsPlans![index]["type"] ==
                                                                "DURATION"
                                                            ? "Ending: " +
                                                                calculateTimeLeft(
                                                                    allSavingsPlans![
                                                                            index]
                                                                        ["created_at"],
                                                                    allSavingsPlans![
                                                                            index]
                                                                        ["duration"])
                                                            : percentageCrushed
                                                                    .toString() +
                                                                "% Achieved",
                                                        style: TextStyle(
                                                            fontSize: 7.sp,
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
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 23.sp),
                                                        GestureDetector(
                                                            onTap: (() => Get.to(Deposit(
                                                                savingsID:
                                                                    allSavingsPlans?[
                                                                        index]["id"],
                                                                savingsName:
                                                                    allSavingsPlans?[
                                                                        index]["name"],
                                                                target: allSavingsPlans?[
                                                                    index]["target"],
                                                                interest:
                                                                    allSavingsPlans?[index]
                                                                        ["interest"],
                                                                totalSaved:
                                                                    allSavingsPlans?[index]
                                                                        ["total_saved"]))),
                                                            child: Icon(
                                                              FontAwesomeIcons.circlePlus,
                                                              color: color.green(),
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
                                                                    fontSize: 7.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight
                                                                        .normal)),
                                                            Text(
                                                                allSavingsPlans?[index][
                                                                            "interest"] ==
                                                                        "0"
                                                                    ? "₦" "0.00"
                                                                    : "₦" +
                                                                        allSavingsPlans?[
                                                                                index]
                                                                            ["interest"],
                                                                style: TextStyle(
                                                                    fontSize: 9.sp,
                                                                    color: Colors.black,
                                                                    fontWeight:
                                                                        FontWeight.bold)),
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
                                                      BorderRadius.circular(18.sp),
                                                  color: Colors.grey.withOpacity(0.1)),
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Business",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: color.green(),
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.lock,
                                                    color: Colors.black, size: 10.sp),
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
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.visibility_off,
                                                    color: Colors.black, size: 10),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text("Not Active",
                                                style: TextStyle(
                                                    fontSize: 7.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              SizedBox(width: 14.sp),
                                              GestureDetector(
                                                  onTap: (() => Get.to(const SetSavings(
                                                        defaultSavingsName:
                                                            "business-default",
                                                      ))),
                                                  child: Icon(
                                                    FontAwesomeIcons.circlePlus,
                                                    color: color.green(),
                                                    size: 17.sp,
                                                  ))
                                            ]),
                                            const SizedBox(height: 10),
                                            Column(children: [
                                              SizedBox(width: 14.sp),
                                              const Text("Interest",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal)),
                                              Text("₦0.00",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
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
                                          borderRadius: BorderRadius.circular(18.sp),
                                          color: Colors.grey.withOpacity(0.1)),
                                    )
                                  : const SizedBox(),
                              extend == true ? SizedBox(height: 5.sp) : SizedBox(),

                              (allSavingsPlans!.isEmpty || allSavingsPlans!.length < 2)
                                  ? Container(
                                      child: Row(children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Rent",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: color.green(),
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.lock,
                                                    color: Colors.black, size: 10.sp),
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
                                                        fontWeight: FontWeight.bold)),
                                                SizedBox(width: 5.sp),
                                                Icon(Icons.visibility_off,
                                                    color: Colors.black, size: 10.sp),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Text("Not Active",
                                                style: TextStyle(
                                                    fontSize: 7.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              SizedBox(width: 14.sp),
                                              GestureDetector(
                                                  onTap: (() => Get.to(const SetSavings(
                                                        defaultSavingsName:
                                                            "rent-default",
                                                      ))),
                                                  child: Icon(
                                                    FontAwesomeIcons.circlePlus,
                                                    color: color.green(),
                                                    size: 17.sp,
                                                  ))
                                            ]),
                                            const SizedBox(height: 10),
                                            Column(children: [
                                              SizedBox(width: 14.w),
                                              Text("Interest",
                                                  style: TextStyle(
                                                      fontSize: 9.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.normal)),
                                              Text("₦0.00",
                                                  style: TextStyle(
                                                      fontSize: 7.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold)),
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
                                          borderRadius: BorderRadius.circular(18.sp),
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
                                          builder: (context, AsyncSnapshot snapshot) {
                                            if (!snapshot.hasData) {
                                              return loader();
                                            } else {
                                              if (snapshot.data.isNotEmpty &&
                                                  snapshot.data != null) {
                                                List? products = snapshot.data;
                                                return ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: products!.length,
                                                  scrollDirection: Axis.horizontal,
                                                  primary: false,
                                                  physics: const BouncingScrollPhysics(),
                                                  separatorBuilder: (c, i) {
                                                    return SizedBox(width: 10.sp);
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context, int index) {
                                                    return Container(
                                                        width: Get.width - 50,
                                                        // height: 120,
                                                        color: Colors.white,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                                child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      25.sp),
                                                              child: CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://statup.ng/statup/" +
                                                                        products[index]
                                                                            ["image"],
                                                                width: Get.width,
                                                                fit: BoxFit.cover,
                                                                height: Get.height < 1100
                                                                    ? 248.sp
                                                                    : 270.sp,
                                                                placeholder: (ctx, text) {
                                                                  return loader();
                                                                },
                                                              ),
                                                            )),
                                                            SizedBox(height: 2.sp),
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
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: Colors
                                                                                .black,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold)),
                                                                    SizedBox(
                                                                        height: 2.sp),
                                                                    Text(
                                                                        products[index][
                                                                            "product_desc"],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                8.sp,
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
                                                                            products[
                                                                                    index]
                                                                                [
                                                                                "product_price"],
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.sp,
                                                                            color: color
                                                                                .green(),
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold)),
                                                                    Row(
                                                                      children: [
                                                                        Text("Sold",
                                                                            textAlign:
                                                                                TextAlign
                                                                                    .center,
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    11.sp,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .bold)),
                                                                        SizedBox(
                                                                            width: 5.w),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(6
                                                                                      .sp),
                                                                              border: Border.all(
                                                                                  color: Color.fromARGB(
                                                                                      255,
                                                                                      207,
                                                                                      207,
                                                                                      207))),
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                                  left: 10
                                                                                      .sp,
                                                                                  right: 10
                                                                                      .sp,
                                                                                  top: 3
                                                                                      .sp,
                                                                                  bottom:
                                                                                      3.sp),
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
                                                                                    11.sp,
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
                                                            SizedBox(height: 2.sp),
                                                            GestureDetector(
                                                                onTap: (() {
                                                                  setState(() {
                                                                    selected_prod_id =
                                                                        products[index]
                                                                            ["id"];

                                                                    selected_prod_price =
                                                                        products[index][
                                                                            "product_price"];

                                                                    selected_prod_name =
                                                                        products[index][
                                                                            "product_name"];
                                                                  });

                                                                  _buy(context);
                                                                }),
                                                                child: Material(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                25.0),
                                                                    elevation: 10.sp,
                                                                    shadowColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            209,
                                                                            209,
                                                                            209),
                                                                    child: Container(
                                                                        height:
                                                                            Get.height >
                                                                                    1300
                                                                                ? 44.sp
                                                                                : 30.sp,
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
                                                                            Radius
                                                                                .circular(
                                                                                    25.0),
                                                                          ),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                              "Buy",
                                                                              style: TextStyle(
                                                                                  fontSize: 12
                                                                                      .sp,
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontWeight:
                                                                                      FontWeight.bold)),
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
                                                  child:
                                                      Text("Could Not Retrieve Products"),
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
                                        borderRadius: BorderRadius.circular(25.0.sp),
                                        elevation: 10,
                                        shadowColor: Color.fromARGB(255, 209, 209, 209),
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
                                                      fontWeight: FontWeight.bold)),
                                            )
                                            //rest of the existing code
                                            )))
                              ])))))),
        ]));
  }

  int percentageAchieved(int totalSaved, int target) {
    double percentage = (totalSaved / target) * 100;

    if (percentage.isNaN || percentage.isInfinite) {
      return 0;
    } else {
      return percentage.round();
    }
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
        child: Container(
            margin: EdgeInsets.only(bottom: 300.sp),
            width: double.maxFinite,
            height: 360.sp,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: Colors.white,
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: (() => {
                            Navigator.of(context, rootNavigator: true).pop(),
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
                      popupItemDisabled: (String s) => s.startsWith('I'),
                      onChanged: (data) {
                        setState(() {
                          state = data.toString();
                        });
                      },
                      selectedItem: state),
                ),
                SizedBox(height: 20.sp),
                CustomField4(
                  hint: "Contact Phone Number",
                  controller: _phoneController,
                  type: TextInputType.numberWithOptions(),
                ),
                SizedBox(height: 10.sp),
                CustomField4(
                  hint: "Contact Address",
                  controller: _addressController,
                ),
                SizedBox(height: 10.sp),
                GestureDetector(
                    onTap: (() {
                      Get.to(Purchase());
                    }),
                    child: GestureDetector(
                        onTap: (() {
                          // Navigator.of(context, rootNavigator: true).pop();

                          _selectEcomPayment(context);
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
                                ))))
              ],
            )),
      )),
    );
  }

  void _selectEcomPayment(BuildContext context) {
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
                                    Navigator.of(context, rootNavigator: true).pop(),
                                  }),
                              child: Icon(Icons.close, size: 20.sp),
                            )
                          ],
                        ),
                        SizedBox(height: 10.sp),
                        Text("Select an option for payment",
                            style: TextStyle(fontSize: 17.sp)),
                        SizedBox(height: 6.sp),
                        Text("Pay directly into our official account.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.sp)),
                        SizedBox(height: 12.sp),
                        Text(statup_corp_bank.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6.sp),
                        Text(statup_corp_num.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: color.green())),
                        SizedBox(height: 6.sp),
                        Text(statup_corp_name.toString(),
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6.sp),
                        GestureDetector(
                            onTap: (() {
                              Get.to(Purchase());
                            }),
                            child: Material(
                                borderRadius: BorderRadius.circular(25.0.sp),
                                elevation: 10.sp,
                                shadowColor: Color.fromARGB(255, 209, 209, 209),
                                child: Container(
                                    height: 40.sp,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 189, 188, 188),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text("Yes, I've Paid!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(255, 31, 30, 30),
                                              fontWeight: FontWeight.bold)),
                                    )
                                    //rest of the existing code
                                    ))),
                        SizedBox(height: 10.sp),
                        Text("OR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 31, 30, 30),
                                fontWeight: FontWeight.bold)),
                        Divider(height: 2.sp, color: Colors.grey),
                        SizedBox(height: 18.sp),
                        GestureDetector(
                            onTap: (() {
                              Get.to(Purchase());
                            }),
                            child: GestureDetector(
                                onTap: (() => {initPurchase()}),
                                child: Material(
                                    borderRadius: BorderRadius.circular(25.0.sp),
                                    elevation: 10.sp,
                                    shadowColor: Color.fromARGB(255, 209, 209, 209),
                                    child: Container(
                                        height: 40.sp,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 223, 223, 223),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text("Pay With Card",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Color.fromARGB(255, 31, 30, 30),
                                                  fontWeight: FontWeight.bold)),
                                        )
                                        //rest of the existing code
                                        )))),
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

  void requestSuccess(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Center(
              child: Material(
                color: Colors.black.withOpacity(.2),
                child: Center(
                  child: Container(
                    width: 250,
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Center(
                        child: Column(children: [
                      const Text(
                          "Your request has been successfully submitted! Once we receive your transfer, your savings wallet will be funded",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: (() => {
                                Navigator.of(context, rootNavigator: true).pop(),
                                Get.to(Landing())
                              }),
                          child: const Text("Go back to home",
                              style: TextStyle(color: Colors.grey, fontSize: 20)))
                    ])),
                  ),
                ),
              ),
            ));
  }

  Future<void> launchPlaystore(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      //print("could not launch link");
      throw 'Could not launch telegram url';
    } else {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> launchAppstore(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      //  print("could not launch link");
      throw 'Could not launch telegram url';
    } else {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    int androidVersion = int.parse(Hive.box("statup").get("android_version"));

    int iosVersion = int.parse(Hive.box("statup").get("ios_version"));

    int version = int.parse(packageInfo.buildNumber);
    int buildNumber = int.parse(packageInfo.buildNumber);

    if (Platform.isIOS) {
      platform = 'iOS';
      if (buildNumber < iosVersion) {
        setState(() {
          updateNotif = true;
        });
      }
    } else {
      if (version < androidVersion) {
        setState(() {
          updateNotif = true;
        });
      }
      platform = 'Android';
    }
  }

  String setSavingsPlansFeName(String name) {
    String feName = "";
    if (name == "business-default") {
      feName = "Business";

      feName = "Business";
    } else if (name == "rent-default") {
      feName = "Rent";

      feName = "Rent";
    } else {
      return name;
    }
    return feName;
  }

  Future<void> initializeSdk() async {
    try {
      _monnifyPaymentSdkPlugin = await Monnify.initialize(
          apiKey: 'MK_PROD_UW7RCZ4MKL',
          contractCode: '800351495208',
          applicationMode: ApplicationMode.LIVE);
      //showToast("SDK initialized!");

    } on PlatformException catch (e, s) {
      print("Error initializing sdk");
      print(e);
      print(s);

      //showToast("Failed to init sdk!");
    }
  }

  Future<void> initPurchase() async {
    try {
      final transactionResponse = await _monnifyPaymentSdkPlugin?.initializePayment(
          transaction: TransactionDetails().copyWith(
        amount: double.parse(selected_prod_price),
        currencyCode: "NGN",
        customerName: firstName + " " + last,
        customerEmail: email.toString(),
        paymentReference: getRandomString(16),
        paymentDescription: "Ecommerce Purchase for $selected_prod_name",
        metaData: const {
          // any other info
        },
        paymentMethods: const [PaymentMethod.CARD],
      ));

      print("tx_reference  ${transactionResponse?.transactionReference}");

      print("tx_status ${transactionResponse?.transactionStatus}");
      if (transactionResponse?.transactionStatus == "PAID") {
        Others()
            .order(
                amount: "100",
                productID: selected_prod_id,
                state: state,
                phone: _phoneController.text,
                address: _addressController.text,
                tx_ref: transactionResponse?.transactionReference)
            .then((value) => {
                  if (value == 1)
                    {
                      Navigator.of(context, rootNavigator: true).pop(),
                      Navigator.of(context, rootNavigator: true).pop(),
                      showToast(
                          "You have successfully made a purchase for the item  $selected_prod_name")
                    }
                  else if (value == 0)
                    {}
                });
      }

      //
    } on PlatformException catch (e, s) {
      print("Error initializing payment");
      print(e);
      print(s);

      showToast("Failed to initialize payment!");
    }
  }

  String getRandomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(
        Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  String calculateTimeLeft(String createdAt, String duration) {
    String savingsExpiryDate = "";
    int timeSavingsCreatedAt = int.parse(createdAt);
    var date = DateTime.fromMillisecondsSinceEpoch(timeSavingsCreatedAt * 1000);

    if (duration == "3") {
      var t_months_time = Jiffy(date).add(months: 3);
      var date_created = Jiffy(date);
      //  var savingsExpiryDate = Jiffy(t_months_time, "yyyy-MM-dd").fromNow();

      int month = int.parse("${t_months_time.diff(date_created, Units.MONTH)}");
      date_created.add(months: month);

      var days = t_months_time.diff(date_created, Units.DAY);

      // print(month.toString() + " months & " + days.toString() + " days");

      return month.toString() +
          " months" +
          (days.toString() == "0" ? "" : (" & " + days.toString()) + " days");
    } else if (duration == "6") {
      var tMonthsTime = Jiffy(date).add(months: 6);
      var date_created = Jiffy(date);
      //  var savingsExpiryDate = Jiffy(t_months_time, "yyyy-MM-dd").fromNow();

      int month = int.parse("${tMonthsTime.diff(date_created, Units.MONTH)}");
      date_created.add(months: month);

      var days = tMonthsTime.diff(date_created, Units.DAY);

      // print(month.toString() + " months & " + days.toString() + " days");

      return month.toString() +
          " months" +
          (days.toString() == "0" ? "" : (" & " + days.toString()) + " days");
    } else if (duration == "9") {
      var tMonthsTime = Jiffy(date).add(months: 9);
      var date_created = Jiffy(date);
      //  var savingsExpiryDate = Jiffy(t_months_time, "yyyy-MM-dd").fromNow();

      int month = int.parse("${tMonthsTime.diff(date_created, Units.MONTH)}");
      date_created.add(months: month);

      var days = tMonthsTime.diff(date_created, Units.DAY);

      // print(month.toString() + " months & " + days.toString() + " days");

      return month.toString() +
          " months" +
          (days.toString() == "0" ? "" : (" & " + days.toString()) + " days");
    }
    if (duration == "12") {
      var tMonthsTime = Jiffy(date).add(months: 12);
      var date_created = Jiffy(date);
      //  var savingsExpiryDate = Jiffy(t_months_time, "yyyy-MM-dd").fromNow();

      int month = int.parse("${tMonthsTime.diff(date_created, Units.MONTH)}");
      date_created.add(months: month);

      var days = tMonthsTime.diff(date_created, Units.DAY);

      // print(month.toString() + " months & " + days.toString() + " days");

      return month.toString() +
          " months" +
          (days.toString() == "0" ? "" : (" & " + days.toString()) + " days");
    }

    return "--";
  }
}
