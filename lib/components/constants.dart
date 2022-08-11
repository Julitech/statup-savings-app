import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/colors.dart';

bool isLiked = false;
myColors color = myColors();

var small_14 = TextStyle(
  color: color.green(),
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

var small_24 =
    TextStyle(color: color.green(), fontSize: 24, fontWeight: FontWeight.w700);

bool validateEmail(String email) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  return emailValid;
}

void showErrorToast(String label) {
  Get.snackbar(
    "Error",
    label,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color.green(),
    borderRadius: 10,
    isDismissible: true,
    margin: const EdgeInsets.all(20),
    colorText: const Color.fromARGB(255, 255, 255, 255),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(seconds: 2),
  );
}

void showToast(String label) {
  Get.snackbar(
    "",
    label,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: color.green(),
    borderRadius: 10,
    isDismissible: true,
    margin: const EdgeInsets.all(20),
    colorText: const Color.fromARGB(255, 255, 255, 255),
    snackStyle: SnackStyle.FLOATING,
    duration: const Duration(seconds: 2),
  );

  // Fluttertoast.showToast(
  //   msg: label,
  //   webPosition: 'center',
  //   backgroundColor: Colors.green,
  //   gravity: ToastGravity.CENTER,
  // );
}

dynamic loading(String label, BuildContext context) {
  showDialog(
    context: context,
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

BoxDecoration decor = const BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/background/bg.png'),
    fit: BoxFit.fill,
  ),
);

PreferredSizeWidget appBar(String label, Color bgcolor, Color txtcolor) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)),
      onPressed: () => {},
    ),
    backgroundColor: bgcolor,
    elevation: 1.0,
    // ignore: prefer_const_literals_to_create_immutables
    actions: [
      const Icon(Icons.notifications_outlined, color: Colors.black, size: 30),
      const SizedBox(width: 20),
      const Icon(Icons.account_circle, color: Colors.black, size: 30),
      const SizedBox(width: 10),
    ],
    title: Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  );
}

class CustomField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: color.green(),
              ),
              hintStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: const Color.fromARGB(255, 65, 65, 65).withOpacity(.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 73, 73, 73)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

Widget loader() {
  return Center(
      child: Container(
          width: 150,
          height: 150,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(color.green()),
            ),
          )));
}

Widget buildMenu() {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 50.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22.0,
                  child: Icon(Icons.account_circle_outlined, size: 35)),
              SizedBox(height: 16.0),
              Text(
                "Hello, John Doe",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
          title: const Text("Home"),
          textColor: Colors.white,
          dense: true,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.verified_user, size: 20.0, color: Colors.white),
          title: const Text("Profile"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.monetization_on,
              size: 20.0, color: Colors.white),
          title: const Text("Wallet"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.shopping_cart, size: 20.0, color: Colors.white),
          title: const Text("Cart"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading:
              const Icon(Icons.star_border, size: 20.0, color: Colors.white),
          title: const Text("Favorites"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.settings, size: 20.0, color: Colors.white),
          title: const Text("Settings"),
          textColor: Colors.white,
          dense: true,

          // padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}

class CustomField1 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField1(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13),
          child: Text(label ?? "", style: small_14),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.0),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                // height: 1.5,
                color: Color.fromARGB(255, 163, 163, 163),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 163, 163, 163)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField2 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField2(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.green,
      obscureText: obscureText ?? false,
      keyboardType: type ?? TextInputType.text,
      style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          height: 1.0),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          // height: 1.5,
          color: Color.fromARGB(255, 163, 163, 163),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255), width: 2),
        ),
        // filled: true,
        // fillColor: node.hasFocus ? black : white,
      ),
    );
  }
}

class CustomField3 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField3(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.0),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 20.0, left: 15),
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 14,
                // height: 1.5,
                color: Color.fromARGB(255, 163, 163, 163),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 163, 163, 163)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField4 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final bool? enabled;
  final Color? focus;
  final FocusNode? node;
  final visible;

  const CustomField4(
      {Key? key,
      this.hint,
      this.enabled,
      this.label,
      this.controller,
      this.type,
      this.visible,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            enabled: enabled,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style:
                const TextStyle(fontSize: 16, color: Colors.black, height: 1.0),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 20.0, left: 15),
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 16,
                // height: 1.5,
                color: Color.fromARGB(255, 163, 163, 163),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: color.green2(), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(color: color.green2(), width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: color.green2())),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField5 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final bool? enabled;
  final Color? focus;
  final FocusNode? node;
  final visible;

  const CustomField5(
      {Key? key,
      this.hint,
      this.enabled,
      this.label,
      this.controller,
      this.type,
      this.visible,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            enabled: enabled,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.0),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 20.0, left: 15),
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 16,
                // height: 1.5,
                color: Color.fromARGB(255, 163, 163, 163),
              ),

              labelText: label,
              labelStyle: TextStyle(
                fontSize: 16,
                // height: 1.5,
                color: color.green().withOpacity(0.6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    BorderSide(color: color.green().withOpacity(0.6), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide:
                    BorderSide(color: color.green().withOpacity(0.6), width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField6 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField6(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: color.green(),
              ),
              hintStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: const Color.fromARGB(255, 65, 65, 65).withOpacity(.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: color.green().withOpacity(.8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: color.green().withOpacity(.8), width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomField7 extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obscureText;
  final Color? focus;
  final FocusNode? node;

  const CustomField7(
      {Key? key,
      this.hint,
      this.label,
      this.controller,
      this.type,
      this.node,
      this.obscureText,
      this.focus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            cursorColor: Colors.green,
            obscureText: obscureText ?? false,
            keyboardType: type ?? TextInputType.text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              // suffixIcon: ,
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: color.green(),
              ),
              hintStyle: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: const Color.fromARGB(255, 65, 65, 65).withOpacity(.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: color.green().withOpacity(.8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: color.green().withOpacity(.8), width: 2),
              ),
              // filled: true,
              // fillColor: node.hasFocus ? black : white,
            ),
          ),
        ),
      ],
    );
  }
}
