// ignore_for_file: unnecessary_import, unused_import, unnecessary_null_comparison
import 'dart:io';

import 'package:buy_verse_app/presentation_layer/admin_version/widgets/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'constant.dart';

Widget defaultTextFormField({
  required BuildContext context,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validate,
  required String label,
  String? hint,
  Function? onTab,
  Function(String)? onChange,
  Function(String)? onSubmit,
  IconData? suffix,
}) => TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(context.setWidth(textFormRadius)),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(fontSize: context.setSp(14), color: Colors.grey),
    hintText: hint,
    suffixIcon: suffix != null
        ? Icon(suffix, size: context.setWidth(20))
        : null,
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.setWidth(15),
      vertical: context.setHeight(15),
    ),
  ),
  keyboardType: type,
  controller: controller,
  onTap: onTab as void Function()?,
  onChanged: onChange,
  onFieldSubmitted: onSubmit,
  validator: validate,
  style: TextStyle(fontSize: context.setSp(14)),
);

// login or register button
Widget defaultButton({
  required BuildContext context,
  double? width,
  double? height,
  Color background = Colors.blue,
  bool isUpperCase = false,
  double? radius,
  required Function() function,
  String? text,
  Widget? widget,
}) {
  return Container(
    width: width ?? double.infinity,
    height: height ?? context.setHeight(55),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        context.setWidth(radius ?? buttonRadius),
      ),
      color: background,
    ),
    child: MaterialButton(
      onPressed: function,
      child:
          widget ??
          Text(
            isUpperCase ? text!.toUpperCase() : text!,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setSp(16),
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
      borderRadius: BorderRadius.circular(context.setWidth(textFormRadius)),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(fontSize: context.setSp(14), color: Colors.grey),
    hintText: hint,
    prefixIcon: prefix,
    suffixIcon: IconButton(
      onPressed: suffixPressed,
      icon: Icon((suffix as Icon).icon, size: context.setWidth(20)),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.setWidth(15),
      vertical: context.setHeight(15),
    ),
  ),
  keyboardType: type,
  controller: controller,
  validator: validate,
  obscureText: isPassword,
  style: TextStyle(fontSize: context.setSp(14)),
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
      borderRadius: BorderRadius.circular(context.setWidth(textFormRadius)),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(fontSize: context.setSp(14), color: Colors.grey),
    hintText: hint,
    prefixIcon: prefix,
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.setWidth(15),
      vertical: context.setHeight(15),
    ),
  ),
  keyboardType: type,
  validator: validate,
  controller: controller,
  style: TextStyle(fontSize: context.setSp(14)),
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
      borderRadius: BorderRadius.circular(context.setWidth(textFormRadius)),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(fontSize: context.setSp(14), color: Colors.grey),
    hintText: hint,
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.setWidth(15),
      vertical: context.setHeight(15),
    ),
  ),
  keyboardType: type,
  controller: controller,
  validator: validate,
  style: TextStyle(fontSize: context.setSp(14)),
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
      borderRadius: BorderRadius.circular(context.setWidth(textFormRadius)),
      borderSide: BorderSide.none,
    ),
    labelText: label,
    labelStyle: TextStyle(fontSize: context.setSp(14), color: Colors.grey),
    hintText: hint,
    suffix: Icon(Icons.calendar_month_outlined, size: context.setWidth(20)),
    contentPadding: EdgeInsets.symmetric(
      horizontal: context.setWidth(15),
      vertical: context.setHeight(15),
    ),
  ),
  keyboardType: type,
  onTap: onTap as void Function(),
  controller: controller,
  validator: validate,
  style: TextStyle(fontSize: context.setSp(14)),
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

void navigateAndFinish(BuildContext context, Widget widget) =>
    navigateToAndFinish(context, widget);

enum ToastStates { SUCCESS, ERROR, WARNING }

void showToast({
  required BuildContext context,
  required String text,
  required ToastStates state,
}) {
  // Clear any existing snackbars immediately to prevent double stacking
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            state == ToastStates.SUCCESS
                ? Icons.check_circle_outline
                : state == ToastStates.ERROR
                ? Icons.error_outline
                : Icons.info_outline,
            color: Colors.white,
          ),
          const Gap(15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: chooseToastColor(state),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(20),
      elevation: 10,
    ),
  );
}

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green.shade600;
    case ToastStates.ERROR:
      return Colors.red.shade600;
    case ToastStates.WARNING:
      return Colors.orange.shade700;
  }
}

// Warning massage
Widget defaultWarningMassage({
  required BuildContext context,
  required String warningText,
  required String text,
  required Function() function,
}) {
  return Container(
    color: Colors.amber,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.setWidth(15),
        vertical: context.setHeight(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.black,
            size: context.setWidth(24),
          ),
          Gap(context.setWidth(15)),
          Expanded(
            child: Text(
              warningText,
              style: TextStyle(fontSize: context.setSp(16)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(context.setWidth(10)),
          TextButton(
            onPressed: function,
            child: Text(
              text,
              style: TextStyle(
                fontSize: context.setSp(16),
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
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios_new, size: context.setWidth(20)),
    ),
    title: Text(
      title,
      style:
          titleTextStyle ??
          TextStyle(fontSize: context.setSp(18), fontWeight: FontWeight.bold),
    ),
    titleSpacing: 0.0,
    actions: actions,
  );
}
