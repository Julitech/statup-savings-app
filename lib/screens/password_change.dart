import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:statup/components/constants.dart';
import 'package:statup/screens/landing.dart';
import '../components/colors.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

import '../services/auth.dart';

class PasswordSettings extends StatefulWidget {
  const PasswordSettings({Key? key}) : super(key: key);

  @override
  _PasswordSettingsState createState() => _PasswordSettingsState();
}

class _PasswordSettingsState extends State<PasswordSettings> {
  var _controller = ValueNotifier<bool>(false);
  bool _checked = false;
  bool? cachedbiometric = Hive.box("statup").get("biometric");

  TextEditingController old_pwd = TextEditingController();
  TextEditingController new_pwd = TextEditingController();
  TextEditingController confirm_new_pwd = TextEditingController();

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
                "Password",
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
                    controller: old_pwd,
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
                      hintText: "Old Password",
                      // suffixIcon: ,
                      labelText: "Old Password",
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
                    controller: new_pwd,
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
                      hintText: "New Password",
                      // suffixIcon: ,
                      labelText: "New Password",
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
                    controller: confirm_new_pwd,
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
                      hintText: "Confirm New Password",
                      // suffixIcon: ,
                      labelText: "Confirm New Password",
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

                SizedBox(height: 250),

                GestureDetector(
                    onTap: (() {
                      if (new_pwd.text.isNotEmpty &&
                          old_pwd.text.isNotEmpty &&
                          confirm_new_pwd.text == new_pwd.text) {
                        loading("loading", context);
                        AuthService()
                            .editPassword(
                              new_password: new_pwd.text,
                              old_password: old_pwd.text,
                            )
                            .then((value) => {
                                  if (value == 1)
                                    {
                                      Get.offAll(const Landing()),
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showErrorToast(
                                          "Password changed successfully"),
                                    }
                                  else if (value == 2)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      print(value.toString()),
                                      showErrorToast(
                                          "Sorry! Could not verify your old password"),
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
                        if (confirm_new_pwd.text != new_pwd.text) {
                          showErrorToast("Password Fields Do Not Match!");
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
                              child: const Text("Change Password",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )
                            //rest of the existing code
                            ))),
              ],
            ))));
  }
}
