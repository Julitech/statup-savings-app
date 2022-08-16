import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:statup/components/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'landing.dart';

class Payment extends StatefulWidget {
  final amount, savings_id, freq, savingsName;
  const Payment({
    Key? key,
    this.amount,
    this.savings_id,
    this.freq,
    this.savingsName,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  WebViewController? _webViewController;
  bool isLoading = true;
  String accessToken = Hive.box("statup").get("access_token");
  String user_id = Hive.box("statup").get("id");

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        child: Stack(children: [
          buildWebView(),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          )
        ]));
  }

  Widget buildWebView() {
    return WebView(
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'messageHandler',
          onMessageReceived: (JavascriptMessage message) {
            print("message from the web view=\"${message.message}\"");

            var data = jsonDecode(message.message);

            if (data["code"] == 1) {
              Hive.box("statup").put("savings", data["data"]["savings"]);
              Get.offAll(Landing());

              showToast("Successfully deposited into ${widget.savingsName}");
            }

            final script =
                "document.getElementById('value').innerText=\"${message.message}\"";
            _webViewController?.runJavascript(script);
          },
        )
      },
      initialUrl: 'about:blank',
      onPageFinished: (finish) {
        setState(() {
          isLoading = false;
        });
      },
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
        String fileContent = await rootBundle.loadString('assets/index.html');
        _webViewController?.loadUrl(
            'https://statup.ng/statup/index.php/goals/payment?amount=${widget.amount}&savings_id=${widget.savings_id}&freq=${widget.freq}&user_id=$user_id'
                .toString());
      },
    );
  }
}
