import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

import 'button_effect.dart';


class CustomButton extends StatelessWidget {
  final double height;
  final String text;
  final VoidCallback onTap;
  final Color color;

  const CustomButton(
      {super.key, this.height = 45, required this.text, required this.onTap, this.color=Style.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: height.h,
          decoration: BoxDecoration(
              color:color,
              borderRadius: BorderRadius.circular(15.r)
          ),
          child: Center(child: Text(
            text, style: Style.normalText(color: Style.whiteColor),),),
        ),
      ),
    );
  }
}
