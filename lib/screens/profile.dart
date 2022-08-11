import 'package:flutter/material.dart';
import 'package:statup/screens/landing.dart';
import 'package:statup/services/auth.dart';
import '../components/banks.dart';
import '../components/constants.dart';
import '../components/colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:dropdown_search2/dropdown_search2.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, this.defaultSavingsName}) : super(key: key);
  final String? defaultSavingsName;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController accName = TextEditingController();
  TextEditingController accNum = TextEditingController();
  final _controller = ValueNotifier<bool>(false);
  FocusNode? firstNameNode;
  FocusNode? lastNameNode;
  FocusNode? emailNode;
  FocusNode? accNameNode;
  FocusNode? accNumNode;
  File? selectedImage;
  bool visibility = false;
  myColors color = myColors();
  Banks banks = Banks();
  String bank = "Select Bank";
  String? cachedEmail = Hive.box("statup").get("email");
  String? cachedFirstName = Hive.box("statup").get("first_name");
  String? cachedLastName = Hive.box("statup").get("last_name");
  String? cachedProfileImg = Hive.box("statup").get("profile_image");
  String? cachedAccName = Hive.box("statup").get("acc_name");
  String? cachedAccNum = Hive.box("statup").get("acc_num");
  String? cachedBank = Hive.box("statup").get("bank");

  @override
  void initState() {
    // _node = FocusNode();
    firstNameNode = FocusNode();
    lastNameNode = FocusNode();

    accNameNode = FocusNode();
    accNumNode = FocusNode();

    emailNode = FocusNode();

    accName.text = cachedAccName.toString();
    accNum.text = cachedAccName.toString();
    bank = cachedBank.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    email.text = cachedEmail.toString();
    firstName.text = cachedFirstName.toString();
    lastName.text = cachedLastName.toString();

    //bank = cachedBank;

    return Scaffold(
      body: Container(
          color: Colors.white,
          height: double.maxFinite,
          child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(const Landing());
                              },
                              child: const Icon(Icons.arrow_back),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Stack(
                                  children: [
                                    // ignore: unnecessary_null_comparison
                                    cachedProfileImg == null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CircleAvatar(
                                              backgroundColor: color.grey2(),
                                              radius: 40,
                                              child: selectedImage != null
                                                  ? Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: FileImage(
                                                                  selectedImage!))))
                                                  : SvgPicture.asset(
                                                      "assets/images/svg/photo-camera-svgrepo-com.svg",
                                                      height: 21,
                                                      width: 21,
                                                      fit: BoxFit.scaleDown,
                                                      color: Colors.black),
                                            ))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CircleAvatar(
                                                backgroundColor: color.grey2(),
                                                radius: 40,
                                                child: selectedImage != null
                                                    ? Container(
                                                        height: 100,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: FileImage(
                                                                    selectedImage!))))
                                                    : cachedProfileImg
                                                                .toString() !=
                                                            ""
                                                        ? Image.network(
                                                            "https://statup.ng/statup/" +
                                                                cachedProfileImg
                                                                    .toString())
                                                        : SvgPicture.asset(
                                                            "assets/images/svg/photo-camera-svgrepo-com.svg",
                                                            height: 21,
                                                            width: 21,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            color:
                                                                Colors.black))),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          ImagePicker picker = ImagePicker();
                                          XFile? file = await picker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 50);
                                          if (file != null) {
                                            setState(() {
                                              selectedImage = File(file.path);
                                            });
                                          }
                                        },
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 51, 51, 51)
                                                    .withOpacity(0.4),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                              ),
                                            ],
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                color.green2(),
                                                color.green2(),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_enhance,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //
                              ],
                            ),
                            const Spacer()
                          ],
                        )),
                    const SizedBox(height: 30),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomField5(
                          label: "First Name",
                          controller: firstName,
                        )),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomField5(
                          label: "Last Name",
                          controller: lastName,
                        )),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomField5(
                          controller: email,
                          label: "Email",
                        )),
                    const SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
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
                                      loading("Saving...", context),
                                      if (firstName.text.isNotEmpty &&
                                          lastName.text.isNotEmpty &&
                                          email.text.isNotEmpty)
                                        {
                                          AuthService()
                                              .updateUser(
                                                  first_name: firstName.text,
                                                  last_name: lastName.text,
                                                  dp: selectedImage,
                                                  email: email.text)
                                              .then((value) => {
                                                    if (value == 1)
                                                      {
                                                        showToast(
                                                            "Your details have been updated!"),
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop(),
                                                      }
                                                  })
                                        }
                                      else
                                        {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(),
                                          showErrorToast(
                                              "Please fill out all field!")
                                        }
                                    },
                                child: Container(
                                  child: const Text("Update Profile",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                )))),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Autosave",
                                      style: TextStyle(
                                          color: color.green(),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text("Automatic Savings"),
                                  ],
                                ),
                                const Spacer(),
                                AdvancedSwitch(
                                  controller: _controller,
                                  activeColor: color.green2(),
                                  inactiveColor: color.grey1(),
                                  height: 15.0,
                                  width: 30,
                                ),
                              ],
                            ))),

//Account Details
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bank Name",
                                      style: TextStyle(
                                          color: color.green(),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      cachedBank.toString() != null
                                          ? cachedBank.toString()
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Account Name",
                                      style: TextStyle(
                                          color: color.green(),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      cachedAccName.toString() != null &&
                                              cachedAccName.toString() != "null"
                                          ? cachedAccName.toString()
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Account Number",
                                      style: TextStyle(
                                          color: color.green(),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      cachedAccNum.toString() != null &&
                                              cachedAccNum.toString() != "null"
                                          ? cachedAccNum.toString()
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )))
                  ])))),
      floatingActionButton: GestureDetector(
        onTap: () => {
          Get.dialog(
            Material(
              color: Colors.black.withOpacity(.2),
              child: Center(
                child: Container(
                  width: double.maxFinite - 40,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                              onTap: (() {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }),
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const Text(
                        "Update Bank Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            // showSelectedItem: true,
                            items: banks.getBanks(),
                            label: "Select Bank",
                            hint: bank,
                            popupItemDisabled: (String s) => s.startsWith('I'),
                            onChanged: (data) {
                              setState(() {
                                bank = data.toString();
                                print("davido + $bank");
                              });
                            },
                            selectedItem: bank),
                      ),
                      const SizedBox(height: 15),
                      CustomField6(
                        label: "Account Name",
                        controller: accName,
                      ),
                      const SizedBox(height: 15),
                      CustomField6(
                        label: "Account Number",
                        controller: accNum,
                        type: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(40), // <-- Radius
                              ),
                              primary: color.green(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              textStyle: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          onPressed: () => {
                                loading("Saving...", context),
                                if (accName.text.isNotEmpty &&
                                    accNum.text.isNotEmpty)
                                  {
                                    AuthService()
                                        .updateBank(
                                          acc_name: accName.text,
                                          acc_num: accNum.text,
                                          bank: bank,
                                        )
                                        .then((value) => {
                                              if (value == 1)
                                                {
                                                  showToast(
                                                      "Your bank details have been updated!"),
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(),
                                                  setState(() {}),
                                                }
                                            })
                                  }
                                else
                                  {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(),
                                    showErrorToast("Please fill out all field!")
                                  }
                              },
                          child: Container(
                            width: double.maxFinite,
                            child: const Text("Save",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
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
          )
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color.green(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              SizedBox(width: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _showMaterialDialog(List list, BuildContext context) {
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
