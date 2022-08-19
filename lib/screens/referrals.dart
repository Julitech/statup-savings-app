import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../components/colors.dart';
import '../components/constants.dart';
import '../services/others.dart';
import '../services/savings.dart';
import 'landing.dart';
import 'profile.dart';

class Referrals extends StatefulWidget {
  const Referrals({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  _ReferralsState createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> {
  myColors color = myColors();

  String? cachedRefCode = Hive.box("statup").get("referral_code");

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
            backgroundColor: Colors.white,
            elevation: 0.0,
            // ignore: prefer_const_literals_to_create_immutables

            title: Text(
              "Referrals",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w200,
                color: color.green(),
              ),
            )),
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 30),
              SvgPicture.asset(
                "assets/images/svg/gift-svgrepo-com.svg",
                height: 100,
                color: color.green(),
                width: 100,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(height: 30),
              Text("Receive ₦500",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: color.green(),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      "There are exciting rewards for you, your family and your friends, when they signup with your referral code and start using StartUp.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ))),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("YOUR REFERRAL CODE",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 59, 59, 59),
                      ))),
              Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Text(cachedRefCode.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 39, 39, 39),
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: (() => {
                              Clipboard.setData(ClipboardData(
                                  text: cachedRefCode.toString())),
                              showToast("Copied to clipboard"),
                            }),
                        child:
                            Icon(Icons.copy, color: color.green(), size: 20)),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: color.green2()),
              ),
              SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                      onTap: (() => {
                            Share.share(
                              cachedRefCode.toString(),
                            )
                          }),
                      child: Material(
                          borderRadius: BorderRadius.circular(25.0),
                          elevation: 10,
                          shadowColor: Color.fromARGB(255, 209, 209, 209),
                          child: Container(
                              height: 50,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: color.green(),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              child: Center(
                                child: const Text("Share Your Referral Code",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ))
                          //rest of the existing code
                          ))),
              SizedBox(height: 10),
              GestureDetector(
                  onTap: (() => {_referrals(context)}),
                  child: Text("My Referrals",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: color.green(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  void _referrals(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
          child: Material(
        color: Colors.black.withOpacity(.2),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
          width: double.maxFinite - 10,
          height: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              children: [
                Text("My Referrals",
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: color.green(),
                      fontSize: 25,
                    )),
                Spacer(),
                GestureDetector(
                    onTap: (() => {
                          Navigator.of(context, rootNavigator: true).pop(),
                        }),
                    child: Icon(Icons.close, color: Colors.black, size: 30)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: Others().getReferrals(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return loader();
                  } else {
                    if (snapshot.data.isNotEmpty && snapshot.data != null) {
                      List? referrals = snapshot.data;
                      return ListView.separated(
                          itemCount: referrals!.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                referrals[index]["first_name"] +
                                    " " +
                                    referrals[index]["last_name"],
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          });
                    } else {
                      return Container(
                          child: const Center(
                              child: Text("Could Not Load Referrals")));
                    }
                  }
                }),
          ])),
        ),
      )),
    );
  }
}
