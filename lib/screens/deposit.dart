import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/screens/payment.dart';
import '/screens/withdraw.dart';
import '/services/savings.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'landing.dart';

class Deposit extends StatefulWidget {
  final savingsID, totalSaved, target, savingsName;
  const Deposit(
      {Key? key,
      this.savingsID,
      this.totalSaved,
      this.target,
      this.savingsName})
      : super(key: key);

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  TextEditingController amt = TextEditingController();

  //TextEditingController goal_name = TextEditingController();
  TextEditingController targetAmt = TextEditingController();

  TextEditingController freqAmt = TextEditingController();

  FocusNode? amtNode;
  FocusNode? goal_nameNode;
  FocusNode? freqNode;
  FocusNode? startAmtNode;
  FocusNode? targetNode;
  bool visibility = false;
  myColors color = myColors();
  var responseCode;
  int trans_code = 0;

  List<String> preselectedSavings = [
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

  bool obs = true;

  @override
  void initState() {
    // _node = FocusNode();

    freqNode = FocusNode();
    startAmtNode = FocusNode();
    targetNode = FocusNode();
    goal_nameNode = FocusNode();

    //Set paystack
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var totalSaved = widget.totalSaved;
    var target = widget.target;

    print(totalSaved + "  " + target);
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
          actions: [
            totalSaved == target
                ? GestureDetector(
                    onTap: (() => {
                          Get.to(Withdraw(
                            total_saved: widget.totalSaved,
                            savingsID: widget.savingsID,
                            savingsName: widget.savingsName,
                          ))
                        }),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/svg/withdraw.svg",
                          height: 23,
                          color: color.green(),
                          width: 23,
                          fit: BoxFit.scaleDown,
                        ),
                        const Text("Withdraw",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                color: Color.fromARGB(255, 26, 151, 30)))
                      ],
                    ))
                : GestureDetector(
                    onTap: (() => {withdrawal_disabled(context)}),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/svg/withdraw.svg",
                          height: 23,
                          color:
                              Color.fromARGB(255, 26, 151, 30).withOpacity(0.5),
                          width: 23,
                          fit: BoxFit.scaleDown,
                        ),
                        Text("Withdraw",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                color: Color.fromARGB(255, 26, 151, 30)
                                    .withOpacity(0.5)))
                      ],
                    ))
          ],
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
                        "You are getting there!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 204, 204, 204),
                            fontSize: 30,
                            fontWeight: FontWeight.normal),
                      ),

                      const SizedBox(height: 27, width: double.maxFinite),
                      const Text(
                        "How much do you want to save?",
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
                            hintText: 'Minimum is N3,000',
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

                      const SizedBox(height: 30, width: double.maxFinite),
                      const Text(
                        "How often do you want to crush your goals?",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30, width: double.maxFinite),

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

                      const SizedBox(height: 60),
                      // Spacer(),
                      SizedBox(
                          width: double.maxFinite,
                          child: GestureDetector(
                              onTap: () => {
                                    if (targetAmt.text.isNotEmpty &&
                                        freqAmt.text.isNotEmpty &&
                                        (int.parse(widget.totalSaved) +
                                                (int.parse(targetAmt.text)) <=
                                            int.parse(widget.target)) &&
                                        int.parse(targetAmt.text) >= 3000)
                                      {
                                        loading("Loading", context),

                                        Get.to(Payment(
                                            amount: targetAmt.text,
                                            savings_id: widget.savingsID,
                                            freq: freqAmt.text,
                                            savingsName: widget.savingsName)),
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        //   Get.to(MobPayTest())
                                        // callQuickTeller()

                                        /* Savings()
                                            .addSavings(
                                                savingsID: widget.savingsID,
                                                targetAmount: targetAmt.text,
                                                // startAmount: starterAmt.text,
                                                frequency: freqAmt.text)
                                            .then((value) => {
                                                  if (value == 1)
                                                    {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      showErrorToast(
                                                          "Successfully deposited  ${targetAmt.text}"),
                                                      Get.to(const Landing())
                                                    }
                                                })*/
                                      }
                                    else
                                      {
                                        if (targetAmt.text.isNotEmpty)
                                          {
                                            if (int.parse(targetAmt.text) <
                                                    3000 ||
                                                targetAmt.text.isEmpty)
                                              {
                                                showErrorToast(
                                                    "The Amount Must Not Be Less Than N3,000 !"),
                                              }
                                            else if ((int.parse(
                                                        widget.totalSaved) +
                                                    (int.parse(
                                                        targetAmt.text)) >
                                                int.parse(widget.target)))
                                              {
                                                showErrorToast(
                                                    "Total Amount Will Be More Than Target!"),
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
          } else if (listName == "preselectedFreq") {
            var finalValue = val.replaceAll(RegExp(','), '');

            setState(() {
              freqAmt.text = finalValue;
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

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void withdrawal_disabled(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
                width: 250,
                height: 150,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Center(
                    child: Text(
                        "Withdrawal disabled! You have not met your savings target yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)))),
          ),
        ),
      ),
    );
  }
}
