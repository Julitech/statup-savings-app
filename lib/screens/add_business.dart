import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'package:get/get.dart';
import '../components/states.dart';
import '../components/business_categories.dart';
import '../components/banks.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import '../services/Invoice.dart';
import 'new_invoice.dart';

class AddBusiness extends StatefulWidget {
  const AddBusiness();

  @override
  _AddBusinessState createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  TextEditingController business_name = TextEditingController();
  TextEditingController business_address = TextEditingController();
  TextEditingController business_phone = TextEditingController();
  TextEditingController acc_name = TextEditingController();
  TextEditingController acc_num = TextEditingController();
  TextEditingController amt = TextEditingController();
  TextEditingController goal_name = TextEditingController();
  myColors color = myColors();
  States states = States();
  Banks banks = Banks();
  Categories categories = Categories();
  bool statesVisibility = false;
  late DateTime currentBackPressTime;
  bool obs = true;
  final _controller = ValueNotifier<bool>(false);
  bool _checked = false;
  String category = "Category";
  String location = "Location";
  String bank = "Select Bank";
  List<File> selectedSignature = [];
  List<File> selectedLogo = [];

  var business;
  String? business_id;
  bool showNetworkImage = false;
  bool showNetworkSignature = false;
  bool networkImage = false;

  @override
  void initState() {
    //Hive.box('statup').delete('businesses');
    business = Hive.box('statup').get('businesses');

    business_id = Hive.box('statup').get('business_id');
    if (business != null && business.isNotEmpty) {
      setState(() {
        business_name.text = business["business_name"];
        business_address.text = business["business_address"];
        category = business["category"];
        location = business["location"];
        business_phone.text = business["phone"];
        acc_num.text = business["acc_num"];
        acc_name.text = business["acc_name"];
        bank = business["bank"];
        print(business["logo"]);

        showNetworkImage = true;
        showNetworkSignature = true;
        networkImage = true;

        if (business["acc_name"] != null) {
          bank = business["bank"];
          _controller.value = true;
        } else {
          bank = "bank";
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          _checked = true;
          print(_checked.toString());
        } else {
          print(_checked.toString());
          _checked = false;
        }
      });
    });

    //

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
                          GestureDetector(
                            child: SvgPicture.asset(
                              "assets/images/svg/left-arrow-svgrepo-com.svg",
                              height: 20,
                              width: 20,
                              fit: BoxFit.scaleDown,
                            ),
                            onTap: Get.back,
                          ),
                          const Spacer(),
                          Column(
                            children: const [
                              SizedBox(height: 10),
                              Text(
                                "Invoice",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 209, 209, 209),
                                    fontSize: 30,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "You can add your business and \n issue receipts to customers",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          const Spacer(),
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
                  showNetworkImage == false
                      ? Center(
                          child: selectedLogo.isNotEmpty
                              ? GestureDetector(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                    if (file != null) {
                                      setState(() {
                                        selectedLogo.clear();
                                        selectedLogo.add(File(file.path));
                                        showNetworkImage = false;
                                        print(showNetworkImage.toString());
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  FileImage(selectedLogo[0])))))
                              : GestureDetector(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                    if (file != null) {
                                      setState(() {
                                        selectedLogo.clear();
                                        selectedLogo.add(File(file.path));
                                        showNetworkImage = false;
                                        print(showNetworkImage.toString());
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    radius: 40,
                                    child: SvgPicture.asset(
                                        "assets/images/svg/photo-camera-svgrepo-com.svg",
                                        height: 21,
                                        width: 21,
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black),
                                  )),
                        )
                      : GestureDetector(
                          onTap: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? file = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            if (file != null) {
                              setState(() {
                                selectedLogo.clear();
                                selectedLogo.add(File(file.path));
                                showNetworkImage = false;
                                print(showNetworkImage.toString());
                              });
                            }
                          },
                          child: Center(
                              child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.network(
                              "http://statup.ng/statup/" + business["logo"],
                              height: 120,
                              width: 120,
                            ),
                          ))),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    "Upload logo",
                    style: TextStyle(
                        color: color.green(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: CustomField1(
                        controller: business_name,
                        obscureText: false,
                        hint: 'Business Name',
                        label: "",
                      )),
                  const SizedBox(height: 25),
                  GestureDetector(
                      onTap: () => _showMaterialDialog(
                          categories.getCategories(), "category"),
                      child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
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
                                  Text(
                                    category,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 163, 163, 163),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
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
                  const SizedBox(height: 25),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: GestureDetector(
                          onTap: () => {
                                _showMaterialDialog(
                                    states.getStates(), "states")
                              },
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
                                  Text(
                                    location,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 163, 163, 163),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
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
                  const SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: CustomField1(
                        controller: business_address,
                        obscureText: false,
                        hint: business_address.text == ""
                            ? "Full Business Address"
                            : business_address.text,
                        label: "",
                      )),
                  const SizedBox(height: 25),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: color.grey(), width: 1)),
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
                                        color: Color.fromARGB(255, 65, 65, 65),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const SizedBox(width: 3),
                                  SizedBox(
                                      width: 250,
                                      height: 20,
                                      child: TextField(
                                        controller: business_phone,
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
                          ))),
                  const SizedBox(height: 20),
                  showNetworkSignature == false
                      ? Center(
                          child: selectedSignature.isNotEmpty
                              ? GestureDetector(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                    if (file != null) {
                                      setState(() {
                                        selectedSignature.clear();
                                        selectedSignature.add(File(file.path));
                                      });
                                    }
                                  },
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(
                                                  selectedSignature[0])))))
                              : GestureDetector(
                                  onTap: () async {
                                    ImagePicker picker = ImagePicker();
                                    XFile? file = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                    if (file != null) {
                                      setState(() {
                                        selectedSignature.clear();
                                        selectedSignature.add(File(file.path));
                                      });
                                    }
                                  },
                                  child: Container(
                                      width: 120,
                                      height: 50,
                                      color: Colors.grey[100],
                                      child: const Icon(Icons.camera_alt,
                                          color: Colors.black, size: 22))),
                        )
                      : GestureDetector(
                          onTap: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? file = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            if (file != null) {
                              setState(() {
                                selectedSignature.clear();
                                selectedSignature.add(File(file.path));
                                showNetworkSignature = false;
                                print(showNetworkSignature.toString());
                              });
                            }
                          },
                          child: Center(
                              child: Image.network(
                            "http://statup.ng/statup/" + business["signature"],
                            height: 120,
                            width: 120,
                          ))),
                  const SizedBox(height: 10),
                  Center(
                      child: Text(
                    "Upload Signature",
                    style: TextStyle(
                        color: color.green(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      const Text(
                        "Add Bank Details",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      AdvancedSwitch(
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
                      const SizedBox(width: 25),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _controller.value == true
                      ? Column(
                          children: [
                            GestureDetector(
                                onTap: () => _showMaterialDialog(
                                    banks.getBanks(), "banks"),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            right: 20,
                                            left: 10),
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
                                            Text(
                                              bank,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 163, 163, 163),
                                                  fontSize: 14,
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
                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: CustomField1(
                                  controller: acc_num,
                                  obscureText: false,
                                  hint: 'Account Number',
                                  label: "",
                                )),
                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: CustomField1(
                                  controller: acc_name,
                                  obscureText: false,
                                  hint: 'Account Name',
                                  label: "",
                                )),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: GestureDetector(
                          onTap: () => {
                                print(business_name.text),
                                print(category),
                                print(location),
                                print(business_phone.text),

                                print(selectedLogo.toString()),
                                print(selectedSignature.toString()),
                                print(networkImage.toString()),

                                if (business_name.text.isNotEmpty &&
                                    business_address.text.isNotEmpty &&
                                    category.isNotEmpty &&
                                    location.isNotEmpty &&
                                    business_phone.text.isNotEmpty)
                                  {
                                    /* if (((selectedLogo.isEmpty ||
                                                selectedSignature.isEmpty) &&
                                            networkImage == true) ||
                                        ((selectedLogo.isNotEmpty &&
                                                selectedSignature.isNotEmpty) &&
                                            networkImage == false) ||
                                        (selectedLogo.isNotEmpty &&
                                                selectedSignature.isNotEmpty) &&
                                            networkImage == true)
                                      {*/
                                    if (_controller.value == true &&
                                        acc_name.text.isNotEmpty &&
                                        acc_num.text.isNotEmpty &&
                                        bank.isNotEmpty)
                                      {
                                        loading("savings...", context),
                                        Invoice()
                                            .newBusiness(
                                                business_name:
                                                    business_name.text,
                                                business_address:
                                                    business_address.text,
                                                category: category,
                                                location: location,
                                                phone: business_phone.text,
                                                bank: bank,
                                                account_name: acc_name.text,
                                                account_num: acc_num.text,
                                                logo: selectedLogo.isNotEmpty
                                                    ? selectedLogo[0]
                                                    : null,
                                                signature:
                                                    selectedSignature.isNotEmpty
                                                        ? selectedSignature[0]
                                                        : null)
                                            .then((value) => {
                                                  if (value == 1)
                                                    {
                                                      Get.to(NewInvoice(
                                                          business_id:
                                                              business_id)),
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                    }
                                                  else
                                                    {
                                                      showErrorToast(
                                                          "An Error  Occured! Please try again!")
                                                    }
                                                })
                                      }
                                    else if (_controller.value == false)
                                      {
                                        Invoice()
                                            .newBusiness(
                                                business_name:
                                                    business_name.text,
                                                business_address:
                                                    business_address.text,
                                                category: category,
                                                location: location,
                                                phone: business_phone.text,
                                                bank: "",
                                                account_name: "",
                                                logo: selectedLogo.isNotEmpty
                                                    ? selectedLogo[0]
                                                    : null,
                                                signature:
                                                    selectedSignature.isNotEmpty
                                                        ? selectedSignature[0]
                                                        : null,
                                                account_num: "")
                                            .then((value) => {
                                                  if (value == 1)
                                                    {Get.to(const NewInvoice())}
                                                  else
                                                    {
                                                      showErrorToast(
                                                          "An Error  Occured! Please try again!")
                                                    }
                                                })
                                        // }
                                      }
                                    else if ((selectedLogo.isEmpty ||
                                            selectedSignature.isEmpty) &&
                                        networkImage == false)
                                      {
                                        showErrorToast(
                                            "Please upload both logo and a signature")
                                      }
                                  }
                                else
                                  {
                                    showErrorToast(
                                        "Please Fill Out All Relevant Fields!")
                                  }
                                //Get.to(NewInvoice())
                              },
                          child: Material(
                              borderRadius: BorderRadius.circular(25.0),
                              elevation: 10,
                              shadowColor: Color.fromARGB(255, 209, 209, 209),
                              child: Container(
                                  height: 40,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: color.green(),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: const Text("Save",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  )
                                  //rest of the existing code
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
                      if (type == "category")
                        {
                          setState(() {
                            category = list[index];
                          }),
                          Navigator.of(context, rootNavigator: true).pop(),
                        }
                      else if (type == "states")
                        {
                          setState(() {
                            location = list[index];
                          }),
                          Navigator.of(context, rootNavigator: true).pop(),
                        }
                      else if (type == "banks")
                        {
                          setState(() {
                            bank = list[index];
                          }),
                          Navigator.of(context, rootNavigator: true).pop(),
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
