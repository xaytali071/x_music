
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

class AvatarImage extends StatelessWidget {
  final double size;
  final String image;

  const AvatarImage({super.key, this.size = 100, required this.image});

  @override
  Widget build(BuildContext context) {
    return image.isEmpty  ?
    Container(
        width: size.w,
        height: size.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Style.primaryColor,

        ),
        child: Center(
          child: Icon(Icons.person,size: size-10.r,color: Style.blackColor50,),
        )
    ) : image.contains("http") ? Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Style.primaryColor,
        image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover
        ),
      ),
    ) : Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Style.primaryColor,
        image: DecorationImage(
            image: FileImage(File(image)),
            fit: BoxFit.cover
        ),
      ),
    );
  }
}
