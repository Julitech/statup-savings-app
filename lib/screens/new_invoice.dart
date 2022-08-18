import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/components/units.dart';
import '/screens/getInvoice.dart';
import '/services/Invoice.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import '../components/states.dart';
import '../components/business_categories.dart';
import '../components/banks.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class NewInvoice extends StatefulWidget {
  final business_id;
  const NewInvoice({Key? key, this.business_id}) : super(key: key);

  @override
  _NewInvoiceState createState() => _NewInvoiceState();
}

class _NewInvoiceState extends State<NewInvoice> {
  TextEditingController customer_name = TextEditingController();
  TextEditingController customer_phone = TextEditingController();
  TextEditingController customer_address = TextEditingController();
  TextEditingController product_name = TextEditingController();
  TextEditingController product_price = TextEditingController();
  String invoice_date = "";
  TextEditingController invoice_number = TextEditingController();
  TextEditingController amt = TextEditingController();
  TextEditingController goal_name = TextEditingController();
  myColors color = myColors();
  States states = States();
  Banks banks = Banks();
  Units units = Units();
  Categories categories = Categories();
  bool statesVisibility = false;
  late DateTime currentBackPressTime;
  var _date_controller;
  bool obs = true;
  final _controller1 = ValueNotifier<bool>(false);
  final _controller2 = ValueNotifier<bool>(false);
  final _controller3 = ValueNotifier<bool>(false);
  bool _checked1 = false;
  bool _checked2 = false;
  bool _checked3 = false;

  String unit = "carton";
  int qty = 0;
  FocusNode? invoiceNode;

  @override
  void initState() {
    var now = DateTime.now();
    var newFormat = DateFormat("dd, MMMM, y");
    String updatedDt = newFormat.format(now);

    setState(() {
      invoice_date = updatedDt;
    });

    invoiceNode = FocusNode();
    _controller1.addListener(() {
      setState(() {
        if (_controller1.value) {
          _checked1 = true;
        } else {
          _checked1 = false;
        }
      });
    });

    //

    _controller2.addListener(() {
      setState(() {
        if (_controller2.value) {
          _checked2 = true;
        } else {
          _checked2 = false;
        }
      });
    });
    //

    _controller3.addListener(() {
      setState(() {
        if (_controller3.value) {
          _checked3 = true;
        } else {
          _checked3 = false;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            color: Colors.white,
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  SizedBox(
                      child: Row(
                    children: const [],
                  )),
                  const SizedBox(height: 30),
                  Container(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg/left-arrow-svgrepo-com.svg",
                            height: 20,
                            width: 20,
                            fit: BoxFit.scaleDown,
                          ),
                          const Spacer(),
                          Column(
                            children: const [
                              SizedBox(height: 25),
                              Text(
                                "New Invoice",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 209, 209, 209),
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.close, color: Colors.black, size: 30)
                        ],
                      ),
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: color.grey2()),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enter Invoice Date & Number",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: (() {
                              _showDateDialog(context);
                            }),
                            child: Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 163, 163, 163))),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 8),
                                        Text(
                                          invoice_date,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 65, 65, 65),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    // Spacer(),
                                  ],
                                )),
                          ),
                          const SizedBox(height: 10),
                          CustomField3(
                            controller: invoice_number,
                            obscureText: false,
                            hint: '12',
                            label: "",
                          )
                        ],
                      )),
                  const SizedBox(height: 40),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Add Customer",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          CustomField3(
                            controller: customer_name,
                            obscureText: false,
                            hint: 'customer name',
                            label: "",
                          ),
                          const SizedBox(height: 10),
                          Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                                left: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 163, 163, 163))),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/svg/ng_logo.svg",
                                        height: 10,
                                        width: 10,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "+234",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(width: 3),
                                      SizedBox(
                                          width: 250,
                                          height: 20,
                                          child: TextField(
                                            controller: customer_phone,
                                            cursorColor: Colors.green,
                                            //  obscureText: obscureText ?? false,
                                            //  keyboardType: type ?? TextInputType.text,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                height: 1.0),
                                            decoration: InputDecoration(
                                              // hintText: hint,
                                              hintStyle: const TextStyle(
                                                fontSize: 14,
                                                // height: 1.5,
                                                color: Color.fromARGB(
                                                    255, 163, 163, 163),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: const BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    width: 2),
                                              ),
                                              // filled: true,
                                              // fillColor: node.hasFocus ? black : white,
                                            ),
                                          )),
                                    ],
                                  ),
                                  // Spacer(),
                                ],
                              )),
                          const SizedBox(height: 10),
                          CustomField3(
                            controller: customer_address,
                            obscureText: false,
                            hint: 'Address',
                            label: "",
                          )
                        ],
                      )),
                  const SizedBox(height: 40),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Add Item",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          CustomField3(
                            controller: product_name,
                            obscureText: false,
                            hint: 'Product',
                            label: "",
                          ),
                          const SizedBox(height: 10),
                          Row(children: [
                            SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 20,
                                        left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 163, 163, 163))),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 3),
                                            const Text(
                                              "N",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(width: 3),
                                            SizedBox(
                                                width: 120,
                                                height: 20,
                                                child: TextField(
                                                  controller: product_price,
                                                  cursorColor: Colors.green,
                                                  //  obscureText: obscureText ?? false,
                                                  //  keyboardType: type ?? TextInputType.text,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.0),
                                                  decoration: InputDecoration(
                                                    // hintText: hint,
                                                    hintStyle: const TextStyle(
                                                      fontSize: 16,
                                                      // height: 1.5,
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              width: 2),
                                                    ),
                                                    // filled: true,
                                                    // fillColor: node.hasFocus ? black : white,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        // Spacer(),
                                      ],
                                    ))),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width / 2),
                              child: GestureDetector(
                                  onTap: () => _showMaterialDialog(
                                      units.getunits(), "unit"),
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 163, 163, 163))),
                                          width: double.maxFinite,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 4),
                                              Text(
                                                unit,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 163, 163, 163),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              const Spacer(),
                                              SvgPicture.asset(
                                                  "assets/images/svg/arrow-down-s-svgrepo-com.svg",
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.scaleDown,
                                                  color: Colors.black),
                                            ],
                                          )))),
                            ),
                            const SizedBox(width: 10)
                          ]),
                          const SizedBox(height: 10),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 20, left: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 163, 163, 163))),
                                  width: double.maxFinite,
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Quantity",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 163, 163, 163),
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: (() {
                                                setState(() {
                                                  if (qty > 0) {
                                                    qty--;
                                                  }
                                                });
                                              }),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: const Center(
                                                    child: Text("-",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20))),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                                .fromARGB(255,
                                                            153, 153, 153)),
                                                    shape: BoxShape.circle,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              )),
                                          const SizedBox(width: 13),
                                          Text(qty.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                          const SizedBox(width: 13),
                                          GestureDetector(
                                              onTap: (() {
                                                setState(() {
                                                  qty++;
                                                });
                                              }),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                                .fromARGB(255,
                                                            153, 153, 153)),
                                                    shape: BoxShape.circle,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ))
                                        ],
                                      )
                                    ],
                                  ))),
                          const SizedBox(height: 20),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "Add Logo",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  AdvancedSwitch(
                                    controller: _controller1,
                                    activeColor: color.green2(),
                                    inactiveColor: color.grey1(),
                                    height: 25.0,
                                  ),
                                ],
                              )),
                          const SizedBox(height: 20),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "Add Bank Details",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  AdvancedSwitch(
                                    controller: _controller2,
                                    activeColor: color.green2(),
                                    inactiveColor: color.grey1(),
                                    height: 25.0,
                                  ),
                                ],
                              )),
                          const SizedBox(height: 20),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "Add Signature",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  AdvancedSwitch(
                                    controller: _controller3,
                                    activeColor: color.green2(),
                                    inactiveColor: color.grey1(),
                                    height: 25.0,
                                  ),
                                ],
                              ))
                        ],
                      )),
                  const SizedBox(height: 25),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: color.green(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () => {
                                    if (invoice_date.isNotEmpty &&
                                        invoice_number.text.isNotEmpty &&
                                        customer_name.text.isNotEmpty &&
                                        customer_phone.text.isNotEmpty &&
                                        customer_address.text.isNotEmpty &&
                                        product_name.text.isNotEmpty &&
                                        product_price.text.isNotEmpty &&
                                        unit.isNotEmpty &&
                                        qty > 0)
                                      {
                                        loading("Creating Invoice", context),
                                        Invoice()
                                            .NewInvoice(
                                                business_id: widget.business_id,
                                                add_logo: _controller1.value,
                                                add_bank: _controller2.value,
                                                add_signature:
                                                    _controller3.value,
                                                invoice_date: invoice_date,
                                                invoice_number:
                                                    invoice_number.text,
                                                customer_name:
                                                    customer_name.text,
                                                customer_phone:
                                                    customer_phone.text,
                                                customer_address:
                                                    customer_address.text,
                                                product_name: product_name.text,
                                                product_price:
                                                    product_price.text,
                                                unit: unit,
                                                qty: qty.toString())
                                            .then((value) => {
                                                  if (value != 0)
                                                    {
                                                      showToast(
                                                          "Invoice created successfully!"),
                                                      Get.to(GetInvoice(
                                                        pdfImage:
                                                            value["pdf_image"],
                                                        pdfFile: value["pdf"],
                                                      )),
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                    }
                                                  else
                                                    {
                                                      showErrorToast(
                                                          "An Error occured! Please try again!")
                                                    }
                                                })
                                      }
                                    else
                                      {
                                        showErrorToast(
                                            "An Error occured! Please Fill out al fields.")
                                      }
                                  },
                              child: Container(
                                child: const Text("Save",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                              )))),
                  const SizedBox(height: 25),
                ]))),
      ],
    ));
  }

  void _showMaterialDialog(List list, String type) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 7),
            width: double.maxFinite - 20,
            height: double.maxFinite,
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () => {
                            if (type == "unit")
                              {
                                setState(() {
                                  unit = list[index];
                                }),
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                              }
                          },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        // margin: EdgeInsets.all(10),
                        // padding: EdgeInsets.all(15),

                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: Color.fromARGB(255, 211, 211, 211)),
                            )),
                        child: Text(
                          list[index],
                          style: const TextStyle(
                            color: Color.fromARGB(255, 44, 44, 44),
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontSize: 22,
                          ),
                        ),
                      ));
                }),
          );
        });
  }

  void _showDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Center(
        child: Material(
          color: Colors.black.withOpacity(.2),
          child: Center(
            child: Container(
              width: 350,
              height: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: SfDateRangePicker(
                  controller: _date_controller,
                  //controller: _controller,
                  // selectionMode: DateRangePickerSelectionMode.single,
                  showActionButtons: true,
                  onCancel: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  onSubmit: (Object? val) {
                    print(val);
                    var now = DateTime.now();
                    DateTime parseDt =
                        val != null ? DateTime.parse(val.toString()) : now;
                    print(parseDt);
                    var newFormat = DateFormat("dd, MMMM, y");
                    String updatedDt = newFormat.format(parseDt);
                    print(updatedDt);
                    setState(() {
                      invoice_date = updatedDt.toString();
                    });
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // 20-04-03
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
