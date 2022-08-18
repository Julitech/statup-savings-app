import 'package:flutter/material.dart';
import '/screens/signup.dart';
import '../components/colors.dart';
import 'login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabsIn extends StatefulWidget {
  const TabsIn({Key? key, this.defaultSavingsName}) : super(key: key);
  final String? defaultSavingsName;

  @override
  _TabsInState createState() => _TabsInState();
}

class _TabsInState extends State<TabsIn> {
  myColors color = myColors();

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    //  myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Text(
              "",
              style: TextStyle(fontSize: 1, color: Colors.grey[100]),
            ),
            backgroundColor: Colors.grey[100],
            elevation: 0.0,
            bottom: TabBar(
              indicatorWeight: 4,
              indicatorColor: color.green(),
              tabs: const [
                Text("Sign Up",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text("Sign In",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              //Icon(Icons.directions_car),

              SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Signup()),

              SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Login()),
            ],
          ),
        ),
      ),
    );
  }
}
