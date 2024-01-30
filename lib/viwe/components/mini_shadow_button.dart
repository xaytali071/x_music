import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/button_effect.dart';
import 'package:xmusic/viwe/components/style.dart';

class MiniShadowButton extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  const MiniShadowButton({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 50.w,
          height: 45.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Style.primaryColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 3),
                color: Style.blackColor50
              )
            ]
          ),
          child: Padding(
            padding:  EdgeInsets.all(10.r),
            child: Image.asset(image,width: 30.w,height: 30.h,),
          ),
        ),
      ),
    );
  }
}
