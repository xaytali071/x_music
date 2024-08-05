
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

class CustomDropDown extends StatelessWidget {
  final List list;
  final Color borderColor;
  final String hint;
  final double width;
  final double height;
  final String? value;
  final ValueChanged? onChanged;
  final String? Function(Object?)? validator;

  const CustomDropDown(
      {super.key,
        required this.list,
        this.borderColor = Style.blackColor17,
        this.value,
        this.width = double.infinity,
        this.height = 40,
        this.hint = "Zikirlar",
        this.onChanged,
        this.validator,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: DropdownButtonFormField(

          hint: Text(
            hint,
          ),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  borderSide: BorderSide(color: borderColor)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  borderSide: BorderSide(
                    color: borderColor,
                  )),
              contentPadding: REdgeInsets.symmetric(horizontal: 5, vertical: 8),
              hintText: hint,
              filled: true),
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
          ),

          borderRadius: BorderRadius.circular(8.r),
          value: value,
          items: list
              .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e ?? "",style: Style.normalText(color: Style.blackColor50),),
          ))
              .toList(),
          onChanged:onChanged),
    );
  }
}
