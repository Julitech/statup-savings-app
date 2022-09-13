import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/screens/landing.dart';
import '/screens/payment.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:math';
import '../services/savings.dart';
import 'deposit.dart';

class SetSavings extends StatefulWidget {
  const SetSavings({Key? key, this.defaultSavingsName}) : super(key: key);
  final String? defaultSavingsName;

  @override
  _SetSavingsState createState() => _SetSavingsState();
}

class _SetSavingsState extends State<SetSavings> {
  TextEditingController targetAmt = TextEditingController();
  TextEditingController starterAmt = TextEditingController();
  TextEditingController freqAmt = TextEditingController();
  TextEditingController duration = TextEditingController();

  FocusNode? amtNode;

  FocusNode? freqNode;
  FocusNode? startAmtNode;
  FocusNode? targetNode;
  bool visibility = false;
  myColors color = myColors();

  var preselected = {"1": "100,000"};
  bool obs = true;
  var savings_plans = [];

  List<String> preselectedSavings = [
    "100,000",
    "200,000",
    "400,000",
    "500,000",
    "1,000,000"
  ];

  List<String> preselectedStartingAmount = [
    "1,000",
    "3,000",
    "5,000",
    "10,000",
    "20,000",
    "40,000",
    "50,000",
    "100,000"
  ];

  List<String> preselectedFreq = [
    "Daily",
    "Weekly",
    "Monthly",
    "Once",
  ];

  List<String> preselectedDuration = [
    "3 months",
    "6 months",
    "9 months",
    "One year",
  ];

  String _ref = "";

  void setRef() {
    Random rand = Random();
    int number = rand.nextInt(2000);

    if (Platform.isAndroid) {
      setState(() {
        _ref = "AndroidRef1789$number";
      });
    } else {
      setState(() {
        _ref = "IOSRef1789$number";
      });
    }
  }

  @override
  void initState() {
    // _node = FocusNode();
    freqNode = FocusNode();
    startAmtNode = FocusNode();
    targetNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => Get.back()
              // open side menu},
              ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Text(
            "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
            color: Colors.white,
            height: double.maxFinite,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      const SizedBox(height: 20, width: double.maxFinite),
                      const Text(
                        "Great Move!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 204, 204, 204),
                            fontSize: 30,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 40, width: double.maxFinite),

                      const Text(
                        "For How Long Will You Save?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      SizedBox(
                        child: TextField(
                          controller: duration,
                          cursorColor: color.green(),
                          obscureText: false,
                          enabled: false,
                          focusNode: freqNode,
                          onTap: () {
                            freqNode?.requestFocus();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: const Color.fromARGB(255, 161, 161, 161)
                                  .withOpacity(.8),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: color.green()),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: color.green(), width: 2),
                            ),
                            // filled: true,
                            // fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20, width: double.maxFinite),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _generateChildren(
                              preselectedDuration, "preselectedDuration")),
                      const SizedBox(height: 27, width: double.maxFinite),

                      const Text(
                        "How much do you want to start with?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      SizedBox(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: starterAmt,
                          cursorColor: color.green(),
                          obscureText: false,
                          focusNode: startAmtNode,
                          onTap: () {
                            startAmtNode?.requestFocus();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Minimum is N1,000',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: const Color.fromARGB(255, 161, 161, 161)
                                  .withOpacity(.8),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: color.green()),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: color.green(), width: 2),
                            ),
                            // filled: true,
                            // fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30, width: double.maxFinite),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _generateChildren(preselectedStartingAmount,
                              "preselectedStartingAmount")),

                      const SizedBox(height: 27, width: double.maxFinite),
                      const Text(
                        "How often do you want to crush your goals?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      SizedBox(
                        child: TextField(
                          controller: freqAmt,
                          enabled: false,
                          cursorColor: color.green(),
                          obscureText: false,
                          focusNode: freqNode,
                          onTap: () {
                            freqNode?.requestFocus();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: const Color.fromARGB(255, 161, 161, 161)
                                  .withOpacity(.8),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: color.green()),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: color.green(), width: 2),
                            ),
                            // filled: true,
                            // fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30, width: double.maxFinite),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _generateChildren(
                              preselectedFreq, "preselectedFreq")),

                      const SizedBox(height: 30),

                      const Text(
                        "This is where you select the target you want to meet for your goal",
                        style: TextStyle(
                            color: Color.fromARGB(255, 204, 204, 204),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      Divider(
                        color: color.grey(),
                        height: 1,
                      ),
                      const SizedBox(height: 60),
                      // Spacer(),
                      SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: color.green(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () => {
                                    if (duration.text.isNotEmpty &&
                                        starterAmt.text.isNotEmpty &&
                                        freqAmt.text.isNotEmpty &&
                                        int.parse(starterAmt.text) >= 1000)
                                      {
                                        loading("Loading", context),
                                        Savings()
                                            .setDefaultSavings(
                                                defaltSavingsName:
                                                    widget.defaultSavingsName,
                                                duration: getSavingsDuration(
                                                    duration.text),
                                                startAmount: starterAmt.text,
                                                frequency: freqAmt.text)
                                            .then((value) => {
                                                  if (value == 1)
                                                    {
                                                      savings_plans =
                                                          Hive.box("statup")
                                                              .get("savings"),
                                                      showToast(
                                                          "New Savings Goal Created!"),
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      Get.to(Deposit(
                                                          savingsID:
                                                              savings_plans[0]
                                                                  ["id"],
                                                          savingsName: widget
                                                              .defaultSavingsName,
                                                          target: "0",
                                                          totalSaved: "0")),
                                                      //  Get.to(const Landing())

                                                      /* Get.to(Payment(
                                                          amount:
                                                              starterAmt.text,
                                                          savings_id:
                                                              savings_plans[0]
                                                                  ["id"],
                                                          freq: freqAmt.text,
                                                          savingsName: widget
                                                              .defaultSavingsName)),*/
                                                      // _handlePaymentInitialization
                                                    }
                                                })
                                      }
                                    else
                                      {
                                        if (duration.text.isEmpty)
                                          {
                                            showErrorToast(
                                                "Please select a valid duration"),
                                          }
                                        else
                                          {
                                            showErrorToast(
                                                "Please fill out all fields!"),
                                          }
                                      }
                                  },
                              child: Container(
                                child: const Text("Continue",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                              ))),
                      const SizedBox(height: 27, width: double.maxFinite),
                    ])))));
  }

  List<Widget> _generateChildren(List preselected, String listName) {
    List<Widget> items = [];

    for (int i = 0; i < preselected.length; i++) {
      items.add(_generateItem(preselected[i], listName));
    }

    return items;
  }

  Widget _generateItem(String val, listName) {
    return GestureDetector(
        onTap: () {
          if (listName == "preselectedTarget") {
            var finalValue = val.replaceAll(RegExp(','), '');
            setState(() {
              targetAmt.text = finalValue;
            });
          } else if (listName == "preselectedStartingAmount") {
            var finalValue = val.replaceAll(RegExp(','), '');
            setState(() {
              starterAmt.text = finalValue;
            });
          } else if (listName == "preselectedFreq") {
            setState(() {
              freqAmt.text = val;
            });
          } else if (listName == "preselectedDuration") {
            setState(() {
              duration.text = val;
            });
          }
        },
        child: Chip(
          label: Text(
            val,
            style: const TextStyle(
              color: Color.fromARGB(255, 107, 107, 107),
              fontSize: 12,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: const StadiumBorder(side: BorderSide(color: Colors.grey)),
        ));
  }

  String getSavingsDuration(String duration) {
    if (duration == "3 months") {
      return "3";
    } else if (duration == "6 months") {
      return "6";
    } else if (duration == "9 months") {
      return "9";
    } else if (duration == "12 months") {
      return "12";
    } else {
      return "0";
    }
  }
}
