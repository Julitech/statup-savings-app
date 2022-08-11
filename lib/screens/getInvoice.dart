import 'package:flutter/material.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'landing.dart';
import 'dart:convert';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class GetInvoice extends StatefulWidget {
  //final savingsID, totalSaved, target;
  final String? pdfImage;
  final String? pdfFile;
  const GetInvoice({Key? key, this.pdfImage, this.pdfFile}) : super(key: key);

  @override
  _GetInvoiceState createState() => _GetInvoiceState();
}

class _GetInvoiceState extends State<GetInvoice> {
  // Track the progress of a downloaded file here.
  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';

  // This method uses Dio to download a file from the given URL
  // and saves the file to the provided `savePath`.

  myColors color = myColors();

  Future<bool> onWillPop() {
    Get.to(Landing());
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
            body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                            onTap: () => Landing(),
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 25,
                            ))
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        height: 450,
                        padding: EdgeInsets.all(5),
                        width: double.maxFinite,
                        child: Image.network(
                            "https://statup.ng/statup/" +
                                widget.pdfImage.toString(),
                            height: 500)),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: GestureDetector(
                            onTap: () async {
                              var tempDir = await getTemporaryDirectory();
                              download(
                                  context,
                                  Dio(),
                                  "https://statup.ng/statup/" +
                                      widget.pdfImage.toString(),
                                  tempDir.path + widget.pdfFile.toString());
                            },
                            child: Icon(Icons.share,
                                size: 30, color: color.green()))),
                    Center(
                        child: GestureDetector(
                            onTap: () async {
                              var tempDir = await getTemporaryDirectory();
                              download(
                                  context,
                                  Dio(),
                                  "https://statup.ng/statup/" +
                                      widget.pdfImage.toString(),
                                  tempDir.path + widget.pdfFile.toString());
                            },
                            child: Text("Share",
                                style: TextStyle(color: color.green()))))
                  ],
                ))));
  }

  Future download(
      BuildContext context, Dio dio, String url, String savePath) async {
    try {
      /* var response = await dio.(
        url,
        onReceiveProgress: updateProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );*/
      /*var file = File(savePath).openSync(mode: FileMode.write);
      file.writeFromSync(response.data);
      await file.close();*/

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/${widget.pdfFile.toString()}';

      await dio.download(
          "https://statup.ng/statup/" + widget.pdfFile.toString(), tempPath,
          onReceiveProgress: (rec, total) {
        setState(() {
          print("downloading");
          // download = (rec / total) * 100;
          print("Downloading File : $rec");
        });
      });
      setState(() {
        print("Completed!");

        Share.shareFiles(['${tempPath}'], text: 'Invoice');

        //openFile(context, tempPath);
      });

      // Here, you're catching an error and printing it. For production
      // apps, you should display the warning to the user and give them a
      // way to restart the download.
    } catch (e) {
      print(e);
    }
  }

  // You can update the download progress here so that the user is
  // aware of the long-running task.
  void updateProgress(done, total) {
    progress = done / total;
    setState(() {
      if (progress >= 1) {
        progressString =
            '✅ File has finished downloading. Try opening the file.';
        didDownloadPDF = true;
      } else {
        progressString = 'Download progress: ' +
            (progress * 100).toStringAsFixed(0) +
            '% done.';
      }
    });
  }

  dynamic openFile(BuildContext context, String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
              width: 250,
              height: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "Your Invoice Is Ready\n \n Press the button below to download and view your invoice",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          primary: color.green(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        try {
                          OpenFile.open(filePath);
                        } catch (e) {
                          print("Sorry! Could not open file!");
                        }
                      },
                      child: Container(
                        child: const Text("View",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
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
