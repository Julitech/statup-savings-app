import 'package:flutter/material.dart';
import '/screens/forgot_password.dart';
import '/screens/landing.dart';
import '/screens/pin.dart';
import '/screens/signup.dart';
import '/screens/verify_otp.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';

import '../services/auth.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool isLoaderVisible = false;
  FocusNode? pwdNode;
  bool visibility = false;
  myColors color = myColors();
  bool enabled = true;
  bool emailValid = false;
  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    pwdNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => isLoaderVisible = !isLoaderVisible,
        child: Stack(children: [
          Scaffold(
              body: Container(
                  color: Colors.white,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        CustomField4(
                          controller: email,
                          obscureText: false,
                          hint: 'Enter Email Address',
                          label: "Email",
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 44,
                              child: TextField(
                                controller: pwd,
                                enabled: enabled,
                                cursorColor: Colors.green,
                                obscureText: obs,
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    height: 1.0),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() => obs = !obs);
                                    },
                                    icon: Icon(
                                      obs
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: color.grey(),
                                      size: 20,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      top: 20.0, left: 15),
                                  enabled: enabled,
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    fontSize: 16,
                                    // height: 1.5,
                                    color: Color.fromARGB(255, 163, 163, 163),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: color.green2(), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: color.green2(), width: 2),
                                  ),
                                  // filled: true,
                                  // fillColor: node.hasFocus ? black : white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 55),
                        GestureDetector(
                            onTap: (() => {
                                  if (isLoaderVisible == false)
                                    {
                                      setState(() {
                                        isLoaderVisible = !isLoaderVisible;
                                        enabled = false;
                                      }),
                                      emailValid =
                                          validateEmail(email.text.toString()),
                                      if (email.text.isNotEmpty &
                                          pwd.text.isNotEmpty)
                                        {
                                          if (emailValid == true)
                                            {
                                              print("processing..."),
                                              AuthService()
                                                  .login(
                                                      email: email.text,
                                                      password: pwd.text)
                                                  .then((value) => {
                                                        if (value == 1)
                                                          {
                                                            showToast(
                                                                "Successful!"),
                                                            Get.to(
                                                                const PinCodeVerificationScreen()),
                                                            setState(() {
                                                              enabled = false;
                                                              isLoaderVisible =
                                                                  !isLoaderVisible;
                                                            }),
                                                          }
                                                        else if (value == 2)
                                                          {
                                                            showErrorToast(
                                                                "Sorry! No account was found with that email!"),
                                                            setState(() {
                                                              enabled = true;

                                                              isLoaderVisible =
                                                                  !isLoaderVisible;
                                                            }),
                                                          }
                                                        else if (value == 3)
                                                          {
                                                            Get.to(
                                                                const ForgotPassword(
                                                              prev:
                                                                  "Your account registration isn't complete. Please follow the steps below to finish...",
                                                            ))
                                                          }
                                                      })
                                            }
                                          else
                                            {
                                              showErrorToast(
                                                  "Please Enter A Valid Email!"),
                                              setState(() {
                                                enabled = false;

                                                isLoaderVisible =
                                                    !isLoaderVisible;
                                              }),
                                            }
                                        }
                                      else
                                        {
                                          showErrorToast(
                                              "Please Confirm Your Password!"),
                                          setState(() {
                                            isLoaderVisible = !isLoaderVisible;

                                            enabled = false;
                                          }),
                                        }
                                    }
                                  else
                                    {
                                      setState(() {
                                        isLoaderVisible = !isLoaderVisible;

                                        enabled = true;
                                      }),
                                      showErrorToast(
                                          "Please fill out all fields")
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
                                      child: const Text("Login",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )
                                    //rest of the existing code
                                    ))),
                        const SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Get.to(const ForgotPassword(
                                    prev: "Recover your account",
                                  ));
                                },
                                child: Text("Forgot Password?",
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
                  ))),
          Visibility(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.grey.withOpacity(0.4),
              child: loader(),
            ),
            visible: isLoaderVisible,
          )
        ]));
  }
}
