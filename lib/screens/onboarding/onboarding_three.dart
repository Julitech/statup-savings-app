import 'package:get/get.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statup/screens/tab_in.dart';

import '../../components/colors.dart';

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({Key? key}) : super(key: key);

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> {
  myColors color = myColors();
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
            height: double.maxFinite,
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                    child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/images/svg/onbording_irrgular.svg",
                              height: Get.height,
                              width: Get.width,
                              fit: BoxFit.fitHeight,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 34, left: 33),
                                child: SvgPicture.asset(
                                  "assets/images/svg/cash-machine-svgrepo-com.svg",
                                  height: 230,
                                  width: 270,
                                )),
                          ],
                        ))),
                SizedBox(height: 35),
                Text(
                  "StaQ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.8)),
                ),
                SizedBox(height: 15),
                Text(
                  "Pay bills and receive money from your personal account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: Colors.black.withOpacity(0.8)),
                ),
                SizedBox(height: 20),
                Center(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: color.green()),
                    )
                  ],
                )),
                Spacer(),
                SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: (() => {Get.to(TabsIn())}),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.2)),
                            )),
                        Spacer(),
                        GestureDetector(
                            onTap: (() => {Get.to(TabsIn())}),
                            child: Material(
                                borderRadius: BorderRadius.circular(25.0),
                                elevation: 10,
                                shadowColor: Color.fromARGB(255, 209, 209, 209),
                                child: Container(
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: color.green(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text("Get Started",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)))
                                    //rest of the existing code
                                    )))
                      ],
                    )),
                SizedBox(height: 30),
              ],
            )));
  }
}
