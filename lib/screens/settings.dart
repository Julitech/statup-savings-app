import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import '/components/constants.dart';
import '/screens/withdrawal_pin.dart';
import '../components/colors.dart';
import 'package:hive/hive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

import 'password_change.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _controller = ValueNotifier<bool>(false);
  bool _checked = false;
  bool? cachedbiometric = Hive.box("statup").get("biometric");

  @override
  void initState() {
    //  callBiometric();
    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          callBiometric();

          cachedbiometric = true;

          print("controller value = ${_controller.value}");
          //;
        } else {
          print("controller.value = ${_controller.value}");
          cachedbiometric = false;
          _checked = false;
        }
      });
    });

    //

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(cachedbiometric.toString());
    myColors color = myColors();
    cachedbiometric == true
        ? _controller.value = true
        : _controller.value = false;

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                    child: const Icon(Icons.arrow_back)),
                const Spacer(),
                const Spacer()
              ],
            ),
            width: double.maxFinite,
            height: 100.0,
            color: color.green()),

        //Menu Items
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/password-svgrepo-com.svg",
                height: 25,
                width: 25,
                color: color.green(),
                fit: BoxFit.scaleDown,
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Change your password',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 11),
                    ),
                  ]),
              onTap: (() => {Get.to(const PasswordSettings())}),
            )),
        /*Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/svg/withdraw.svg",
                height: 25,
                width: 25,
                color: color.green(),
                // fit: BoxFit.scaleDown,
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Withdrawal Pin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Set your withdrawal pin',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 11),
                    ),
                  ]),
              onTap: () => {Get.to(WithdrawSettings())},
            )),*/

        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              /* trailing: AdvancedSwitch(
                controller: _controller,
                activeColor: color.green2(),
                inactiveColor: color.grey1(),
                thumb: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color.green()),
                ),
                height: 25.0,
              )*/
              leading: SvgPicture.asset(
                "assets/images/svg/passcode.svg",
                height: 25,
                width: 25,
                color: color.green(),
                // fit: BoxFit.scaleDown,
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passcode',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Secure app & withdrawals with 4-digit passcode',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 11),
                    ),
                  ]),
              onTap: () => {Get.to(WithdrawSettings())},
            )),

        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: color.grey2()),
              ),
              color: Colors.white,
            ),
            child: ListTile(
              trailing: AdvancedSwitch(
                controller: _controller,
                activeColor: color.green2(),
                inactiveColor: color.grey1(),
                thumb: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color.green()),
                ),
                height: 25.0,
              ),
              leading: Icon(
                Icons.fingerprint,
                size: 25,
                color: color.green(),
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometrics',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.green(),
                          fontSize: 15),
                    ),
                    Text(
                      'Secure app with fingerprint',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.grey(),
                          fontSize: 11),
                    ),
                  ]),
              onTap: () => {},
            )),
      ],
    ));
  }

  Future<void> callBiometric() async {
    //Check biometric support

    print("checking biometric");
    final LocalAuthentication auth = LocalAuthentication();
    // ···
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.

      print("biometrics enrolled");
    }

    if (availableBiometrics.contains(BiometricType.strong)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
      print("fingerprint");

      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to set biometrics',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
            sensitiveTransaction: false,
          ));

      if (didAuthenticate == true) {
        Hive.box("statup").put("biometric", true);
        showToast("Biometrics set successfully!");
      } else {
        showErrorToast(
            "Sorry! Could not authenticate! Please try a different method");
      }
    } else {
      print(availableBiometrics.toString());
    }
  }

  dynamic loading(String label, BuildContext context) {
    showDialog(
      context: this.context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(color.green()),
                  ),
                  const SizedBox(height: 20),
                  Text(label, textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
