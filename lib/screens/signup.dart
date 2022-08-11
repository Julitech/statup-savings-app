import 'package:flutter/material.dart';
import 'package:statup/screens/verify_otp.dart';
import 'package:statup/services/auth.dart';
import '../components/constants.dart';
import 'package:get/get.dart';
import '../components/colors.dart';

class Signup extends StatefulWidget {
  const Signup();

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController ref = TextEditingController();
  TextEditingController pwdConfirm = TextEditingController();

  FocusNode? pwdNode;
  FocusNode? pwdConfirmNode;
  bool visibility = false;
  myColors color = myColors();
  bool emailValid = false;
  bool isLoaderVisible = false;
  bool enabled = true;

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    pwdNode = FocusNode();
    pwdConfirmNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
                    const SizedBox(height: 30),
                    CustomField4(
                      controller: fname,
                      obscureText: false,
                      hint: 'First Name',
                      label: "First Name",
                      enabled: enabled,
                    ),
                    const SizedBox(height: 10),
                    CustomField4(
                      controller: lname,
                      obscureText: false,
                      hint: 'Last Name',
                      label: "Last Name",
                      enabled: enabled,
                    ),
                    const SizedBox(height: 10),
                    CustomField4(
                      controller: email,
                      obscureText: false,
                      hint: 'Enter your email...',
                      label: "Email",
                      enabled: enabled,
                    ),
                    const SizedBox(height: 20),
                    CustomField4(
                      controller: phone,
                      obscureText: false,
                      hint: 'Phone Number',
                      label: "Phone Number",
                      enabled: enabled,
                    ),
                    const SizedBox(height: 20),
                    CustomField4(
                      controller: ref,
                      obscureText: false,
                      hint: 'Referred ID (optional)',
                      label: "Referred ID",
                      enabled: enabled,
                    ),
                    const SizedBox(height: 20),
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
                                fontSize: 16, color: Colors.black, height: 1.0),
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
                              contentPadding:
                                  const EdgeInsets.only(top: 20.0, left: 15),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                // height: 1.5,
                                color: Color.fromARGB(255, 163, 163, 163),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: color.green2(), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: color.green2(), width: 2),
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      BorderSide(color: color.green2())),
                              // filled: true,
                              // fillColor: node.hasFocus ? black : white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: pwdConfirm,
                            enabled: enabled,
                            cursorColor: color.green(),
                            obscureText: obs,
                            focusNode: pwdConfirmNode,
                            onTap: () {
                              pwdConfirmNode?.requestFocus();
                            },
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(top: 13.0, left: 15),

                              hintText: 'Re-enter your password...',
                              hintStyle: const TextStyle(
                                fontSize: 16,
                                // height: 1.5,
                                color: Color.fromARGB(255, 163, 163, 163),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() => obs = !obs);
                                },
                                icon: Icon(
                                    obs
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: color.grey(),
                                    size: 20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: color.green2(), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(color: color.green2(), width: 2),
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      BorderSide(color: color.green2())),
                              // filled: true,
                              // fillColor: Colors.white,
                            ),
                          ),
                        ]),
                    const SizedBox(height: 55),
                    GestureDetector(
                        onTap: (() {
                          if (isLoaderVisible == false) {
                            setState(() {
                              isLoaderVisible = !isLoaderVisible;
                              enabled = false;
                            });
                            emailValid = validateEmail(email.text.toString());
                            if (email.text.isNotEmpty &
                                fname.text.isNotEmpty &
                                lname.text.isNotEmpty &
                                phone.text.isNotEmpty) {
                              if (pwd.text == pwdConfirm.text) {
                                if (emailValid == true) {
                                  print("processing...");
                                  AuthService()
                                      .signup(
                                          email: email.text,
                                          phone: phone.text,
                                          first_name: fname.text,
                                          last_name: lname.text,
                                          referrer: ref.text,
                                          pwd: pwd.text)
                                      .then((value) => {
                                            if (value == 1)
                                              {
                                                showToast(
                                                    "Account Successfully Created!!"),
                                                Get.offAll(const Otp()),
                                                setState(() {
                                                  enabled = false;
                                                  isLoaderVisible =
                                                      !isLoaderVisible;
                                                }),
                                              }
                                            else
                                              {
                                                showErrorToast(
                                                    value.toString()),
                                                setState(() {
                                                  enabled = true;

                                                  isLoaderVisible =
                                                      !isLoaderVisible;
                                                }),
                                              }
                                          });
                                } else {
                                  showErrorToast("Please Enter A Valid Email!");
                                  setState(() {
                                    enabled = true;

                                    isLoaderVisible = !isLoaderVisible;
                                  });
                                }
                              } else {
                                showErrorToast("Please Confirm Your Password!");
                                setState(() {
                                  isLoaderVisible = !isLoaderVisible;

                                  enabled = true;
                                });
                              }
                            } else {
                              setState(() {
                                isLoaderVisible = !isLoaderVisible;

                                enabled = true;
                              });
                              showErrorToast("Please fill out all fields");
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
                                  child: const Text("SignUp",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                )
                                //rest of the existing code
                                ))),
                    const SizedBox(height: 25),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              children: [
                                TextSpan(
                                    text: "By continuing, you agree to our"),
                                TextSpan(
                                    text: " Terms and Conditions",
                                    style: TextStyle(color: color.orange())),
                                TextSpan(text: " of service and"),
                                TextSpan(
                                    text: " Privacy Policy",
                                    style: TextStyle(color: color.orange())),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 30),
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
    ]);
  }
}
