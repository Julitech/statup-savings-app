import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screens/landing.dart';
import '/services/savings.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../components/constants.dart';
import '../services/others.dart';

class Legal extends StatefulWidget {
  const Legal();

  @override
  _LegalState createState() => _LegalState();
}

class _LegalState extends State<Legal> {
  myColors color = myColors();
  TextEditingController message = TextEditingController();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool obs = true;
  @override
  void initState() {
    // _node = FocusNode();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
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

          title: const Text(
            "Legal Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w200,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: WebView(
              initialUrl: 'https://statup.com.ng/privacypolicy',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            )));
  }
}
