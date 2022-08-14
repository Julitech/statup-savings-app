import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statup/services/savings.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../components/constants.dart';

class Transaction extends StatefulWidget {
  const Transaction();

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  myColors color = myColors();

  bool obs = true;
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
            leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0)),
                onPressed: () => Get.back()
                // open side menu},
                ),
            backgroundColor: color.green(),
            elevation: 0.0,
            // ignore: prefer_const_literals_to_create_immutables

            title: const Center(
              child: Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            )),
        body: FutureBuilder(
            future: Savings().transactions(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return loader();
              } else {
                if (snapshot.data.isNotEmpty && snapshot.data != null) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                        width: double.maxFinite,
                        height: Get.height - 60,
                        child: ListView.separated(
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              List? transactions = snapshot.data;
                              print(transactions.toString());
                              String tx_type =
                                  transactions![index]["type"].toString();

                              tx_type = tx_type.replaceFirst(
                                  tx_type[0], tx_type[0].toUpperCase());

                              return Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/svg/diagonal-arrow-svgrepo-com.svg",
                                        height: 15,
                                        color: color.green(),
                                        width: 15,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        children: [
                                          Text(tx_type,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15)),
                                          const SizedBox(width: 6),
                                          Text(
                                              transactions[index]["created"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: color.grey())),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          Text(
                                              "₦${transactions[index]["amount"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                          const SizedBox(width: 6),
                                          Text(transactions[index]["status"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14,
                                                  color: color.green())),
                                        ],
                                      ),
                                    ],
                                  ));
                            })),
                  );
                } else {
                  return Container(
                      child: Center(
                    child: Text("No transactions yet",
                        style: TextStyle(fontSize: 16)),
                  ));
                }
              }
            }));
  }
}
