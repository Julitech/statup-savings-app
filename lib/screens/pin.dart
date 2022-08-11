import 'dart:async';

import 'package:statup/services/auth.dart';
import 'package:get/get.dart';
import '../components/constants.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'landing.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  const PinCodeVerificationScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();
  //
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  StreamController<ErrorAnimationType>? errorController1;
  late DateTime currentBackPressTime;

  bool hasError = false;
  bool hasError1 = false;
  String currentText = "";
  String confirmText = "";
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    errorController1 = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    errorController1!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
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
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 100),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Set 4-Digit Login Passcode',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8),
                        child: RichText(
                          text: const TextSpan(
                              text:
                                  "This Pin Will Also Be Used For Withdrawals",
                              style: TextStyle(
                                  color: Color.fromARGB(137, 0, 0, 0),
                                  fontSize: 13)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: color.green(),
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: true,
                              // obscuringCharacter: '*',
                              obscuringWidget: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 3) {
                                  //return "I'm from validator";
                                } else {
                                  return null;
                                }
                                return null;
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  fieldHeight: 90,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: color.green(),
                                  fieldWidth: 60,
                                  selectedColor: color.green(),
                                  errorBorderColor: Colors.grey,
                                  activeFillColor: Colors.white,
                                  activeColor: color.green()),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: false,

                              backgroundColor: Colors.white,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,

                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.white,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                debugPrint(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8),
                        child: RichText(
                          text: const TextSpan(
                              text: "Confirm 4-digit passcode",
                              style: TextStyle(
                                  color: Color.fromARGB(137, 0, 0, 0),
                                  fontSize: 13)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Form(
                        key: formKey1,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 50),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: TextStyle(
                                color: color.green(),
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: true,
                              // obscuringCharacter: '*',
                              obscuringWidget: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 3) {
                                  //return "I'm from validator";
                                } else {
                                  return null;
                                }
                                return null;
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  fieldHeight: 90,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: color.green(),
                                  fieldWidth: 60,
                                  selectedColor: color.green(),
                                  errorBorderColor: Colors.grey,
                                  activeFillColor: Colors.white,
                                  activeColor: color.green()),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: false,

                              backgroundColor: Colors.white,
                              errorAnimationController: errorController1,
                              controller: textEditingController1,
                              keyboardType: TextInputType.number,

                              boxShadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.white,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                debugPrint(value);
                                setState(() {
                                  confirmText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          hasError1 ? "*Passcodes are not the same!" : "",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 240, 25, 25),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          hasError ? "*Please enter a 4-digit passcode!" : "",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 240, 25, 25),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30),
                        child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: GestureDetector(
                                onTap: () => {
                                      // print(Hive.box("statup").get("access_token")),
                                      formKey.currentState!.validate(),
                                      // conditions for validating
                                      if ((currentText.length != 4 &&
                                          currentText == "1234"))
                                        {
                                          errorController!.add(ErrorAnimationType
                                              .shake), // Triggering error shake animation
                                          setState(() => hasError = true),
                                        }
                                      else if (currentText != confirmText)
                                        {
                                          errorController1!.add(ErrorAnimationType
                                              .shake), // Triggering error shake animation
                                          setState(() => hasError1 = true),
                                        }
                                      else
                                        {
                                          setState(
                                            () {
                                              hasError = false;
                                              hasError1 = false;
                                              loading("Loading", context);

                                              AuthService()
                                                  .setPIN(pin: currentText)
                                                  .then((value) => {
                                                        if (value == 1)
                                                          {
                                                            showToast(
                                                                "Verification pin created!"),
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop(),
                                                            Get.offAll(
                                                                const Landing())
                                                          }
                                                        else
                                                          {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop(),
                                                            showErrorToast(
                                                                "An error occured!")
                                                          }
                                                      });
                                            },
                                          ),
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
                                          child: const Text("Set PIN",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                        //rest of the existing code
                                        )))),
                        decoration: BoxDecoration(
                          // color: Colors.green.shade300,
                          borderRadius: BorderRadius.circular(5),
                          /*  boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 219, 219, 219),
                          offset: Offset(1, 1),
                          blurRadius: 2),
                    ]*/
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
