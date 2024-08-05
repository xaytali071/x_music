
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style.dart';
import 'button_effect.dart';

class MiniButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Color color;
  final VoidCallback onTap;
  const MiniButton({super.key,  this.height=35, required this.child,this.width=double.infinity, required this.onTap,this.color=Style.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          width: 60.r,
          height: height.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: color.withOpacity(0.5),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}