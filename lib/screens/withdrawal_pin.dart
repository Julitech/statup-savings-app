import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:statup/components/constants.dart';
import '../components/colors.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

import '../services/auth.dart';
import 'landing.dart';

class WithdrawSettings extends StatefulWidget {
  const WithdrawSettings({Key? key}) : super(key: key);

  @override
  _WithdrawSettingsState createState() => _WithdrawSettingsState();
}

class _WithdrawSettingsState extends State<WithdrawSettings> {
  var _controller = ValueNotifier<bool>(false);
  bool _checked = false;
  bool? cachedbiometric = Hive.box("statup").get("biometric");

  TextEditingController pwd = TextEditingController();
  TextEditingController new_pin = TextEditingController();
  TextEditingController confirm_new_pin = TextEditingController();

  FocusNode? old_pwdNode;

  FocusNode? new_pwdNode;
  bool visibility = false;
  myColors color = myColors();
  bool emailValid = false;
  bool isLoaderVisible = false;
  bool enabled = true;

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    old_pwdNode = FocusNode();
    new_pwdNode = FocusNode();
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => loadDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    print(cachedbiometric.toString());
    myColors color = myColors();
    cachedbiometric == true
        ? _controller.value = true
        : _controller.value = false;

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () => Get.back()
                // open side menu},
                ),
            backgroundColor: color.green(),
            elevation: 0.0,
            // ignore: prefer_const_literals_to_create_immutables

            title: Row(children: [
              SizedBox(width: 50),
              Text(
                "Passcode",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            ])),
        body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                //Enter old password
                SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: pwd,
                    cursorColor: Colors.green,
                    obscureText: obs,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => obs = !obs);
                        },
                        icon: Icon(
                          obs ? Icons.visibility : Icons.visibility_off,
                          color: color.grey(),
                          size: 20,
                        ),
                      ),
                      hintText: "Password",
                      // suffixIcon: ,
                      labelText: "Password",
                      labelStyle: TextStyle(
                          fontSize: 12, height: 1.5, color: color.grey()),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: color.grey(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: color.grey().withOpacity(.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: color.grey().withOpacity(.4), width: 2),
                      ),
                      // filled: true,
                      // fillColor: node.hasFocus ? black : white,
                    ),
                  ),
                ),

                //Enter New Password

                SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: new_pin,
                    cursorColor: Colors.green,
                    obscureText: obs,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => obs = !obs);
                        },
                        icon: Icon(
                          obs ? Icons.visibility : Icons.visibility_off,
                          color: color.grey(),
                          size: 20,
                        ),
                      ),
                      hintText: "New PIN",
                      // suffixIcon: ,
                      labelText: "New PIN",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: color.grey(),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: color.grey(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: color.grey().withOpacity(.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: color.grey().withOpacity(.4), width: 2),
                      ),
                      // filled: true,
                      // fillColor: node.hasFocus ? black : white,
                    ),
                  ),
                ),

                SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: confirm_new_pin,
                    cursorColor: Colors.green,
                    obscureText: obs,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => obs = !obs);
                        },
                        icon: Icon(
                          obs ? Icons.visibility : Icons.visibility_off,
                          color: color.grey(),
                          size: 20,
                        ),
                      ),
                      hintText: "Confirm New PIN",
                      // suffixIcon: ,
                      labelText: "Confirm New PIN",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: color.grey(),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: color.grey(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: color.grey().withOpacity(.4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: color.grey().withOpacity(.4), width: 2),
                      ),
                      // filled: true,
                      // fillColor: node.hasFocus ? black : white,
                    ),
                  ),
                ),

                SizedBox(height: 80),

                GestureDetector(
                    onTap: (() {
                      if (new_pin.text.isNotEmpty &&
                          pwd.text.isNotEmpty &&
                          confirm_new_pin.text == new_pin.text) {
                        loading("loading", context);
                        AuthService()
                            .editPasscode(
                              password: pwd.text,
                              new_pin: new_pin.text,
                            )
                            .then((value) => {
                                  if (value == 1)
                                    {
                                      Get.offAll(const Landing()),
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showErrorToast(
                                          "PIN changed successfully"),
                                    }
                                  else if (value == 2)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      print(value.toString()),
                                      showErrorToast(
                                          "Sorry! Could not verify your password"),
                                    }
                                  else
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      print(value.toString()),
                                      showErrorToast("Sorry! An error occured"),
                                    }
                                });
                      } else {
                        if (confirm_new_pin.text != new_pin.text) {
                          showErrorToast("PIN Fields Do Not Match!");
                        } else {
                          showErrorToast("Please fill out all fields properly");
                        }
                      }
                    }),
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
                              child: const Text("Change PIN",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )
                            //rest of the existing code
                            )))
              ],
            ))));
  }

  loadDialog(BuildContext context) {
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
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                      "You are about to change your 4-digit passcode. This passcode will also be used as your withdrawal PIN",
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Material(
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
                          child: GestureDetector(
                              onTap: (() {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                              child: const Center(
                                child: Text("Continue",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
