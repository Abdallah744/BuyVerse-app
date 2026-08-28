// ignore_for_file: unnecessary_import, unused_import, unnecessary_null_comparison
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

Widget defaultTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validate,
  required String label,
  String? hint,
  Function? onTab,
  IconData? suffix,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFormRadius),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      color: Colors.grey,
    ),
    hintText: hint,
    suffixIcon: suffix != null ? Icon(suffix) : null,
  ),
  keyboardType: type,
  controller: controller,
  onTap: onTab as void Function()?,
  validator: validate,
  style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04),
);

// login or register button
Widget defaultButton({
  required BuildContext context,
  double width = double.infinity,
  double? height,
  Color background = Colors.blue,
  bool isUpperCase = false,
  double radius = 10.0,
  required Function() function,
  required String text,
}) {
  double screenWidth = MediaQuery.sizeOf(context).width;
  double screenHeight = MediaQuery.sizeOf(context).height;

  return Container(
    width: width,
    height: height ?? screenHeight * 0.065,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(buttonRadius),
      color: background,
    ),
    child: MaterialButton(
      onPressed: function,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

// password FormFiled Box
Widget passwordTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  String? hint,
  required bool isPassword,
  required String? Function(String?) validate,
  required String label,
  Widget? prefix,
  Widget suffix = const Icon(Icons.remove_red_eye),
  required Function() suffixPressed,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFormRadius),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      color: Colors.grey,
    ),
    hintText: hint,
    prefixIcon: prefix,
    suffixIcon: IconButton(onPressed: suffixPressed, icon: suffix),
  ),
  keyboardType: type,
  controller: controller,
  validator: validate,
  obscureText: isPassword,
  style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04),
);

// email FormFiled Box
Widget emailTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  String? hint,
  required String? Function(String?) validate,
  required String label,
  Widget? prefix,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFormRadius),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      color: Colors.grey,
    ),
    hintText: hint,
    prefixIcon: prefix,
  ),
  keyboardType: type,
  validator: validate,
  controller: controller,
  style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04),
);

// name FormFiled Box
Widget nameTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  String? hint,
  required String? Function(String?) validate,
  required String label,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFormRadius),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      color: Colors.grey,
    ),
    hintText: hint,
  ),
  keyboardType: type,
  controller: controller,
  validator: validate,
  style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04),
);

Widget dateTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  required Function onTap,
  String? hint,
  required String? Function(String?) validate,
  required String label,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(textFormRadius),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(
      fontSize: MediaQuery.sizeOf(context).width * 0.04,
      color: Colors.grey,
    ),
    hintText: hint,
    suffix: const Icon(Icons.calendar_month_outlined),
  ),
  keyboardType: type,
  onTap: onTap as void Function(),
  controller: controller,
  validator: validate,
  style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.04),
);

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateToAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

// Warning massage
Widget defaultWarningMassage({
  required BuildContext context,
  required String warningText,
  required String text,
  required Function() function,
}) {
  double screenWidth = MediaQuery.sizeOf(context).width;

  return Container(
    color: Colors.amber,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 12.0,
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.black,
            size: screenWidth * 0.06,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              warningText,
              style: TextStyle(fontSize: screenWidth * 0.045),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: function,
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
  TextStyle? titleTextStyle,
}) {
  double screenWidth = MediaQuery.sizeOf(context).width;

  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back_ios_new),
    ),
    title: Text(
      title,
      style:
          titleTextStyle ??
          TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
    ),
    titleSpacing: 0.0,
    actions: actions,
  );
}
