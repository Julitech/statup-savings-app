import 'package:flutter/material.dart';
import '/screens/pin.dart';
import '/screens/signup.dart';
import '/services/auth.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Otp extends StatefulWidget {
  const Otp();

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController otp = TextEditingController();

  FocusNode? otpNode;
  bool visibility = false;
  myColors color = myColors();
  late DateTime currentBackPressTime;

  String userEmail = Hive.box("statup").get("email");
  String userID = Hive.box("statup").get("userID");

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    otpNode = FocusNode();
    super.initState();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press back again to exit app", gravity: ToastGravity.TOP);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            body: Container(
                color: Colors.white,
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 150),
                      Text("One More Step",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 27,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(
                          "We've sent a verification code, enter it here to verify your email.",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 30),
                      CustomField(
                        controller: otp,
                        obscureText: false,
                        hint: 'Enter Otp Here',
                        label: "OTP",
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                          width: (MediaQuery.of(context).size.width) - 10,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                  primary: color.green(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () => {
                                    loading("loading", context),
                                    AuthService()
                                        .verifyOTP(
                                            email: userEmail,
                                            userID: userID,
                                            otp: otp.text)
                                        .then((value) => {
                                              if (value == 1)
                                                {
                                                  Get.offAll(
                                                      const PinCodeVerificationScreen()),
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                }
                                              else
                                                {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                  print(value.toString()),
                                                  print(otp.text),
                                                  print(userEmail),
                                                  print(userID),
                                                  showErrorToast(
                                                      "Sorry! Could not verify. Please try again!"),
                                                }
                                            })
                                  },
                              child: Container(
                                width: double.maxFinite,
                                child: const Text("Verify",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                              ))),
                      const SizedBox(height: 25),
                      GestureDetector(
                          onTap: (() => {
                                loading("loading", context),
                                AuthService()
                                    .resendEmail(
                                      userEmail.toString(),
                                    )
                                    .then((value) => {
                                          if (value == 1)
                                            {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(),
                                              showErrorToast(
                                                  "Code re-sent Successfully!"),
                                            }
                                          else
                                            {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(),
                                              showErrorToast(
                                                  "Sorry!An error occured Could not verify. Please try again!"),
                                            }
                                        })
                              }),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Didn't get it?  ",
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(const Signup());
                                  },
                                  child: Text("Resend",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: color.green(),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ))
                    ],
                  ),
                ))));
  }
}
