import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:statup/screens/tab_in.dart';
import 'package:statup/services/auth.dart';
import 'package:get/get.dart';
import '../components/constants.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:hive/hive.dart';
import 'landing.dart';
import 'package:local_auth/local_auth.dart';

class PinLoginScreen extends StatefulWidget {
  final String? phoneNumber;

  const PinLoginScreen({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _PinLoginScreenState createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool? biometric = false;
  bool next = false;
  String? firstName;
  String? lastName;
  @override
  void initState() {
    biometric = Hive.box("statup").get("biometric");

    firstName = Hive.box("statup").get("first_name");
    lastName = Hive.box("statup").get("last_name");

    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

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

  @override
  Widget build(BuildContext context) {
    return next == true
        ? Landing()
        : Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      firstName! + " " + lastName!,
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Please enter your PIN to continue",
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.4)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 7,
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

                              formKey.currentState!.validate();
                              // conditions for validating
                              if (currentText.length != 4 &&
                                  currentText == "1234") {
                                errorController!.add(ErrorAnimationType
                                    .shake); // Triggering error shake animation
                                setState(() => hasError = true);
                              } else {
                                setState(
                                  () {
                                    hasError = false;
                                    loading("Verifying...", context);

                                    AuthService()
                                        .loginWithPIN(pin: currentText)
                                        .then((value) => {
                                              if (value == 1)
                                                {
                                                  showToast("Welcome!"),
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                  Get.to(const Landing())
                                                }
                                              else
                                                {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                  showErrorToast(
                                                      "An error occured!")
                                                }
                                            });
                                  },
                                );
                              }
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
                    hasError
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              hasError
                                  ? "*Please enter a four digit number"
                                  : "",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    biometric == true
                        ? GestureDetector(
                            onTap: () => callBiometric(),
                            child: Icon(Icons.fingerprint_outlined,
                                size: 40, color: color.green()))
                        : SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: (() => {
                            Hive.box('statup').delete('access_token'),
                            Hive.box('statup').delete('savings'),
                            Hive.box('statup').delete('businesses'),
                            Hive.box('statup').delete('first_name'),
                            Hive.box('statup').delete('last_name'),
                            Hive.box('statup').delete('email'),
                            Hive.box('statup').delete('loggedIn'),
                            Hive.box('statup').delete('pin'),
                            Get.offAll(TabsIn())
                          }),
                      child: Text("Logout",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> callBiometric() async {
    //Check biometric support

    print("checking biometric");
    final LocalAuthentication auth = LocalAuthentication();
    // ···
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.

      print("biometrics enrolled");
    }

    if (availableBiometrics.contains(BiometricType.strong)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
      print("fingerprint");

      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Login with your fingerprint',
          options: const AuthenticationOptions(biometricOnly: true));

      if (didAuthenticate == true) {
        Hive.box("statup").put("biometric", true);
        showToast("Verification Successful");

        setState(() {
          next = true;
        });
      } else {
        showErrorToast(
            "Sorry! Could not authenticate! Please try a different method");
      }
    } else {
      print(availableBiometrics.toString());
    }
  }
}
