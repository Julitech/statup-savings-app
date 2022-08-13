import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:statup/screens/payment.dart';
import 'package:statup/services/savings.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';

import 'landing.dart';

class CustomiseGoals extends StatefulWidget {
  const CustomiseGoals();

  @override
  _CustomiseGoalsState createState() => _CustomiseGoalsState();
}

class _CustomiseGoalsState extends State<CustomiseGoals> {
  TextEditingController amt = TextEditingController();

  TextEditingController goal_name = TextEditingController();
  TextEditingController targetAmt = TextEditingController();
  TextEditingController starterAmt = TextEditingController();
  TextEditingController freqAmt = TextEditingController();
  var savings_plans = [];

  FocusNode? amtNode;
  FocusNode? goal_nameNode;
  FocusNode? freqNode;
  FocusNode? startAmtNode;
  FocusNode? targetNode;
  bool visibility = false;
  myColors color = myColors();

  List<String> preselectedSavings = [
    "100,000",
    "200,000",
    "400,000",
    "500,000",
    "1,000,000"
  ];

  List<String> preselectedStartingAmount = [
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

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    freqNode = FocusNode();
    startAmtNode = FocusNode();
    targetNode = FocusNode();
    goal_nameNode = FocusNode();
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

                      //Set Goals Name
                      const SizedBox(height: 40, width: double.maxFinite),
                      const Text(
                        "Name your goal",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      SizedBox(
                        child: TextField(
                          maxLength: 50,
                          controller: goal_name,
                          cursorColor: color.green(),
                          obscureText: false,
                          //focusNode: amtNode,
                          onTap: () {
                            goal_nameNode?.requestFocus();
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

                      const SizedBox(height: 27, width: double.maxFinite),
                      const Text(
                        "Enter or select a preferred savings target",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10, width: double.maxFinite),
                      SizedBox(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: targetAmt,
                          cursorColor: color.green(),
                          obscureText: false,
                          focusNode: amtNode,
                          onTap: () {
                            targetNode?.requestFocus();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Minimum is N100,000',
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
                              preselectedSavings, "preselectedTarget")),

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
                          controller: starterAmt,
                          keyboardType: TextInputType.number,
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
                            hintText: 'Minimum is N5,000',
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
                      const SizedBox(height: 30, width: double.maxFinite),
                      Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _generateChildren(
                              preselectedFreq, "preselectedFreq")),

                      const SizedBox(height: 60),
                      // Spacer(),
                      SizedBox(
                          width: double.maxFinite,
                          child: GestureDetector(
                              onTap: () => {
                                    if (targetAmt.text.isNotEmpty &&
                                        starterAmt.text.isNotEmpty &&
                                        freqAmt.text.isNotEmpty &&
                                        goal_name.text.isNotEmpty &&
                                        int.parse(targetAmt.text) >= 100000 &&
                                        int.parse(starterAmt.text) >= 3000)
                                      {
                                        loading("Loading", context),
                                        Savings()
                                            .setDefaultSavings(
                                                defaltSavingsName:
                                                    goal_name.text,
                                                targetAmount: targetAmt.text,
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

                                                      Get.to(Payment(
                                                          amount:
                                                              starterAmt.text,
                                                          savings_id:
                                                              savings_plans[0]
                                                                  ["id"],
                                                          freq: freqAmt.text,
                                                          savingsName:
                                                              goal_name.text)),

                                                      // Get.to(const Landing())
                                                    }
                                                })
                                      }
                                    else
                                      {
                                        if (targetAmt.text.isNotEmpty)
                                          {
                                            if (int.parse(targetAmt.text) <
                                                    100000 ||
                                                targetAmt.text.isEmpty)
                                              {
                                                showErrorToast(
                                                    "The Target Must Not Be Less Than N100,000 !"),
                                              }
                                            else if (int.parse(
                                                    starterAmt.text) <
                                                3000)
                                              {
                                                showErrorToast(
                                                    "The Starting Amount Must Not Be Less Than N5,000 !"),
                                              }
                                          }
                                        else
                                          {
                                            showErrorToast(
                                                "Please fill out all fields!"),
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
                                        child: const Text("Save",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      )
                                      //rest of the existing code
                                      )))),

                      const SizedBox(height: 10),
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
}
