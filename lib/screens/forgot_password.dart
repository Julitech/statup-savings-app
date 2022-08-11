import 'package:flutter/material.dart';
import 'package:statup/screens/landing.dart';
import 'package:statup/screens/new_password.dart';
import 'package:statup/screens/signup.dart';
import 'package:statup/screens/verify_otp.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth.dart';
import 'pin.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword();

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool isLoaderVisible = false;
  FocusNode? pwdNode;
  bool visibility = false;
  myColors color = myColors();
  bool enabled = true;
  bool emailValid = false;
  bool obs = true;
  late DateTime currentBackPressTime;
  @override
  void initState() {
    // _node = FocusNode();
    pwdNode = FocusNode();
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
                      Text("Recover Account",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      Text(
                          "Enter your email here and we'll send a code to your email",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 30),
                      CustomField4(
                        controller: email,
                        obscureText: false,
                        hint: 'Email',
                        label: "Email",
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                          onTap: () => {
                                loading("loading", context),
                                AuthService()
                                    .forgotPassword(
                                      email: email.text,
                                    )
                                    .then((value) => {
                                          if (value == 1)
                                            {
                                              Get.offAll(const NewPassword()),
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
                                              print(email.text),
                                              showErrorToast(
                                                  "Sorry! Could not verify. Please try again!"),
                                            }
                                        })
                              },
                          child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              elevation: 10,
                              shadowColor: Color.fromARGB(255, 209, 209, 209),
                              child: Container(
                                  height: 40,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: color.green(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text("Send Code",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  )
                                  //rest of the existing code
                                  ))),
                      const SizedBox(height: 25),
                    ],
                  ),
                ))));
  }
}
