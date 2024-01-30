import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/components/style.dart';

class AvatarButton extends StatelessWidget {
  final double size;

  const AvatarButton({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<UserCubit>().getImageGallery(() {});
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return state.imagePath==null ?
            Container(
            width: size.w,
            height: size.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.primaryColor,

            ),
            child: Center(
              child: Icon(Icons.photo_camera_rounded,size: size-20.r,color: Style.blackColor50,),
            )
          ) : Container(
              width: size.w,
              height: size.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.primaryColor,
                image: DecorationImage(
                    image: FileImage(File(state.imagePath ?? "")),
                    fit: BoxFit.cover
                ),
              ),
          );
        },
      ),
    );
  }
}
