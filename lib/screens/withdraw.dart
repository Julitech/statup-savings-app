import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../components/colors.dart';
import '../components/constants.dart';
import '../services/savings.dart';
import 'landing.dart';
import 'profile.dart';

class Withdraw extends StatefulWidget {
  final savingsID, savingsName, total_saved;
  const Withdraw({
    Key? key,
    this.savingsID,
    this.savingsName,
    this.total_saved,
  }) : super(
          key: key,
        );

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  myColors color = myColors();

  TextEditingController amt = TextEditingController();
  TextEditingController targetNewName = TextEditingController();
  TextEditingController targetNew = TextEditingController();
  bool enabled = true;
  String? hasError;
  String? cachedProfileImg = Hive.box("statup").get("profile_image");
  String? cachedAccName = Hive.box("statup").get("acc_name");
  String? cachedAccNum = Hive.box("statup").get("acc_num");
  String? cachedBank = Hive.box("statup").get("bank");

  @override
  void initState() {
    // _node = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    targetNewName.text = widget.savingsName;
    hasError = "";
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.to(const Profile());
            },
            child: CircleAvatar(
              backgroundColor: color.green(),
              radius: 10,
              child: cachedProfileImg.toString() != ""
                  ? Image.network(
                      "https://statup.ng/statup/" + cachedProfileImg.toString(),
                      height: 22,
                      width: 22)
                  : const Icon(Icons.account_circle,
                      color: Colors.black, size: 22),
            ),

            //
          ),
          backgroundColor: color.green(),
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Center(
            child: Text(
              "Withdrawal",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: Get.back,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Bank details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: color.green2(),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cachedBank.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: color.green()),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Fidelity Bank Plc",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      //
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Account name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: color.green()),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        cachedAccName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Account number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: color.green()),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        cachedAccNum.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ]),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Withdrawal Request",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                child: TextField(
                  controller: amt,
                  cursorColor: Colors.green,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "",
                    // suffixIcon: ,
                    labelText: "Amount ( ₦ )",
                    labelStyle: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: color.green().withOpacity(.5),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: color.green().withOpacity(.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: color.green().withOpacity(.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: color.green().withOpacity(.5), width: 2),
                    ),
                    // filled: true,
                    // fillColor: node.hasFocus ? black : white,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Request will be processed within 24hrs",
                textAlign: TextAlign.center,
                style: TextStyle(color: color.grey().withOpacity(.7)),
              )),
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                  onTap: (() {
                    print(widget.total_saved);
                    if (cachedAccName == null ||
                        cachedAccName == "" ||
                        cachedAccNum == null ||
                        cachedAccNum == "" ||
                        cachedBank == null ||
                        cachedBank == "") {
                      setAccount(context);
                    } else if (amt.text.isNotEmpty &&
                        (int.parse(amt.text) < int.parse(widget.total_saved))) {
                      extendGoal(context);
                    } else if (amt.text.isNotEmpty &&
                        (int.parse(amt.text) ==
                            int.parse(widget.total_saved))) {
                      loading("Loading", context);
                      //   Get.to(MobPayTest())
                      // callQuickTeller()

                      Savings()
                          .withdraw(
                              amount: amt.text,
                              savingsID: widget.savingsID,
                              savingsName: targetNewName.text,
                              newTargetAmt: targetNew.text,
                              newTarget: targetNewName.text)
                          .then((value) => {
                                if (value == 1)
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                    showErrorToast(
                                        "Successfully submitted withdrawal request"),
                                    Get.to(const Landing()),
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                  }
                              });
                    } else {
                      if (amt.text.isNotEmpty &&
                          (int.parse(amt.text) >
                              int.parse(widget.total_saved))) {
                        showErrorToast("Amount greater than total saved");
                      } else if (amt.text.isEmpty) {
                        showErrorToast("Pleas enter a valid amount!");
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
                          child: const Center(
                            child: Text("Send Request",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                          //rest of the existing code
                          ))),
            ],
          )),
        ));
  }

  dynamic extendGoal(BuildContext context) {
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
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: (() => {
                              Navigator.of(context, rootNavigator: true).pop(),
                            }),
                        child: Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Maintain existing target",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CustomField4(
                    controller: targetNewName,
                    obscureText: false,
                    hint: widget.savingsName,
                    enabled: enabled,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "₦ ${widget.total_saved}.00",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color.green()),
                      ),
                      Spacer(),
                      Icon(
                        Icons.check_circle_outline,
                        color: color.grey(),
                        size: 17,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Your new target will continue from your old balance",
                    style: TextStyle(fontSize: 12, color: color.grey()),
                  ),
                  const SizedBox(height: 15),
                  Divider(
                    height: 2,
                    color: color.grey().withOpacity(0.3),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Enter new target",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CustomField4(
                    controller: targetNew,
                    obscureText: false,
                    hint: "Minimum is ₦100,000",
                    type: TextInputType.number,
                    enabled: enabled,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hasError!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 30),
                  GestureDetector(
                      onTap: (() {
                        if (int.parse(amt.text) <=
                                int.parse(widget.total_saved) &&
                            amt.text.isNotEmpty &&
                            (int.parse(targetNew.text) >= 100000) &&
                            int.parse(targetNew.text) >
                                ((int.parse(widget.total_saved) -
                                    int.parse(amt.text)))) {
                          loading("Loading", context);
                          //   Get.to(MobPayTest())
                          // callQuickTeller()

                          Savings()
                              .withdraw(
                                  amount: amt.text,
                                  savingsID: widget.savingsID,
                                  savingsName: targetNewName.text,
                                  newTargetAmt: targetNew.text,
                                  newTarget: targetNewName.text)
                              .then((value) => {
                                    if (value == 1)
                                      {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                        showErrorToast(
                                            "Successfully submitted withdrawal request"),
                                        Get.to(const Landing()),
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(),
                                      }
                                  });
                        } else {
                          if (amt.text.isNotEmpty &&
                              (int.parse(amt.text) >
                                  int.parse(widget.total_saved))) {
                            showErrorToast("Amount greater than total saved");
                            setState(() {
                              hasError = "Amount greater than total saved";
                            });
                          } else if (amt.text.isEmpty) {
                            showErrorToast("Please enter a valid amount!");
                          } else if (int.parse(targetNew.text) <=
                              ((int.parse(widget.total_saved) -
                                  int.parse(amt.text)))) {
                            showErrorToast(
                                "New target less than existing savings!");
                            setState(() {
                              hasError =
                                  "New target less than existing savings!";
                            });
                          } else if (int.parse(amt.text) < 100000) {
                            showErrorToast(
                                "Please enter a target amount greater than N100,000 as new target");
                            setState(() {
                              hasError =
                                  "Please enter a target amount greater than N100,000 as new target";
                            });
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
                                child: const Text("Send Request",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )
                              //rest of the existing code
                              )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                    "Your Account Details Have Not Be Set Properly",
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

                                Get.to(Profile());
                              }),
                              child: Center(
                                child: const Text("Set Account Details",
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
