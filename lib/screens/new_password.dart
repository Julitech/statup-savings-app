import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/screens/landing.dart';
import '/screens/signup.dart';
import '/screens/verify_otp.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth.dart';
import 'forgot_password.dart';
import 'pin.dart';

class NewPassword extends StatefulWidget {
  const NewPassword();

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController code = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController cpwd = TextEditingController();
  String? email = Hive.box("statup").get("email");
  bool isLoaderVisible = false;
  FocusNode? pwdNode;
  FocusNode? cpwdNode;
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
    cpwdNode = FocusNode();
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
                      Text("Change Password",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 14),
                      Text(
                          "Enter The Code You Received And A New Password For Your Account",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(height: 30),
                      CustomField4(
                        controller: code,
                        obscureText: false,
                        hint: 'Code',
                        label: "Code",
                      ),
                      const SizedBox(height: 15),
                      CustomField4(
                        controller: pwd,
                        obscureText: true,
                        hint: 'New Password',
                        label: "New Password",
                      ),
                      const SizedBox(height: 15),
                      CustomField4(
                        controller: cpwd,
                        obscureText: true,
                        hint: 'Confirm New Password',
                        label: "Confirm New Password",
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                          width: (MediaQuery.of(context).size.width) - 10,
                          child: GestureDetector(
                              onTap: () => {
                                    if (pwd.text.isNotEmpty &&
                                        code.text.isNotEmpty &&
                                        cpwd.text == pwd.text)
                                      {
                                        loading("loading", context),
                                        AuthService()
                                            .changePassword(
                                              password: pwd.text,
                                              email: email,
                                              code: code.text,
                                            )
                                            .then((value) => {
                                                  if (value == 1)
                                                    {
                                                      Get.offAll(
                                                          const PinCodeVerificationScreen()),
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                    }
                                                  else
                                                    {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      print(value.toString()),
                                                      print(email),
                                                      showErrorToast(
                                                          "Sorry!An error occured Could not verify. Please try again!"),
                                                    }
                                                })
                                      }
                                    else
                                      {
                                        if (cpwd.text != pwd.text)
                                          {
                                            showErrorToast(
                                                "Password Fields Do Not Match!"),
                                          }
                                        else
                                          {
                                            showErrorToast(
                                                "Please fill out all fields properly"),
                                          }
                                      }
                                  },
                              child: Material(
                                  borderRadius: BorderRadius.circular(25.0),
                                  elevation: 10,
                                  shadowColor:
                                      Color.fromARGB(255, 209, 209, 209),
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
                                        child: const Text("Set Password",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      )
                                      //rest of the existing code
                                      )))),
                      const SizedBox(height: 25),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                // Get.to(const ForgotPassword());

                                loading("loading", context);

                                AuthService()
                                    .resendEmail(
                                      email.toString(),
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
                                        });
                              },
                              child: Text("Resend Code",
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: color.green(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                        ],
                      )
                    ],
                  ),
                ))));
  }
}
