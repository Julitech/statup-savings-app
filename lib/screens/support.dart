import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statup/screens/landing.dart';
import 'package:statup/services/savings.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../components/constants.dart';
import '../services/others.dart';

class Support extends StatefulWidget {
  const Support();

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  myColors color = myColors();
  TextEditingController message = TextEditingController();

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          backgroundColor: color.green(),
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: Text(
            "Support",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                CustomField8(
                  controller: message,
                  obscureText: false,
                  hint: 'Please type a message here...',
                  label: "Message",
                ),
                SizedBox(height: 20),
                GestureDetector(
                    onTap: (() => {
                          Others()
                              .support(message: message.text)
                              .then((value) => {
                                    if (value == 1)
                                      {
                                        showToast(
                                            "You've successfully sent a support message"),

                                        /* Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop(),
                                                            Get.offAll(
                                                                const Landing())*/
                                      }
                                    else
                                      {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        showErrorToast(
                                            "An error occured! Please try again")
                                      }
                                  })
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
                              child: const Text("Send",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )
                            //rest of the existing code
                            )))
              ],
            )));
  }

  dynamic setAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              width: double.maxFinite - 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 7),
                  Text(
                    "You have successfully reached our customer care. We will respond to you by email within 24 hours. \n Please be patient",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: color.grey()),
                  ),
                  const SizedBox(height: 15),
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

                                Get.to(Landing());
                              }),
                              child: Center(
                                child: const Text("Go Back",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ))
                          //rest of the existing code
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
