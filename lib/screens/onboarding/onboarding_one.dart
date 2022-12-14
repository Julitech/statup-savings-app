import 'package:get/get.dart';
import 'package:onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statup/screens/onboarding/onboarding_two.dart';

import '../../components/colors.dart';
import '../tab_in.dart';

class OnboardingOne extends StatefulWidget {
  const OnboardingOne({Key? key}) : super(key: key);

  @override
  State<OnboardingOne> createState() => _OnboardingOneState();
}

class _OnboardingOneState extends State<OnboardingOne> {
  myColors color = myColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  "assets/images/svg/deposit-svgrepo-com.svg",
                                  height: 230,
                                  width: 270,
                                )),
                          ],
                        ))),
                SizedBox(height: 35),
                Text(
                  "Savings Goals",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.8)),
                ),
                SizedBox(height: 15),
                Text(
                  "Set and meet savings goals for various needs",
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
                          shape: BoxShape.circle, color: color.green()),
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
                          shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
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
                            onTap: (() =>
                                {Navigator.of(context).push(_createRoute())}),
                            child: Material(
                                borderRadius: BorderRadius.circular(25.0),
                                elevation: 10,
                                shadowColor: Color.fromARGB(255, 209, 209, 209),
                                child: Container(
                                    height: 40,
                                    width: 67,
                                    decoration: BoxDecoration(
                                      color: color.green(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                    ),
                                    child: Center(
                                        child: Icon(Icons.arrow_forward_ios,
                                            color: Colors.white))
                                    //rest of the existing code
                                    )))
                      ],
                    )),
                SizedBox(height: 30),
              ],
            )));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingTwo(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return child;
      },
    );
  }
}
