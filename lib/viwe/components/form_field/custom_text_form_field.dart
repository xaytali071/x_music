import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? sufix;
  final Widget? perfix;
  final Color borderColor;
  final bool obscure;
  final Color filledColor;
  final TextInputType keyBoardType;
  final Function(String)? onChanged;

  const CustomTextFormField(
      {super.key,
      required this.hint,
      this.controller,
      this.sufix,
      this.perfix,
      this.onChanged,
        this.filledColor=Style.primaryColor,
      this.keyBoardType = TextInputType.text,
        this.obscure=false,
        this.borderColor=Style.transperntColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      obscureText:obscure ,
      keyboardType: keyBoardType,
      style: Style.normalText(color: Style.darkPrimaryColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Style.normalText(color: Style.darkPrimaryColor),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: borderColor)),
        fillColor: filledColor.withOpacity(0.5),
        filled: true,
        constraints: BoxConstraints.tightFor(height: 35.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),

        suffixIcon: sufix,
        prefixIcon: perfix,
      ),
    );
  }
}
