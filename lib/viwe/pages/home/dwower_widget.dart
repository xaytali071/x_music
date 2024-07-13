import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/model/user_model.dart';
import 'package:xmusic/viwe/components/avatar_image.dart';
import 'package:xmusic/viwe/components/custom_social_button.dart';
import 'package:xmusic/viwe/components/style.dart';

import '../../../controller/providers.dart';

class DrawerWidget extends ConsumerWidget {
  final Key dkey;
  final UserModel? userInfo;
  const DrawerWidget({super.key, required this.dkey, required this.userInfo});

  @override
  Widget build(BuildContext context,ref) {
    AppState watch=ref.watch(appProvider);
    final event=ref.read(appProvider.notifier);
        return Drawer(
          backgroundColor: watch.darkMode ? Style.blackColor : Style.whiteColor,
          key: dkey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                50.verticalSpace,
                AvatarImage(image: userInfo?.avatar ?? ""),
                20.verticalSpace,
                SizedBox(
                    width: 250.w,
                    child: Text(userInfo?.name ?? "",style: Style.normalText(color:watch.darkMode ? Style.whiteColor : Style.blackColor,size: 14),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.dark_mode), text: "Darkmode", onTap: (){},rightIcon: Switch(value: watch.darkMode, onChanged: (bool value) {
                  event.darkMode(value);
                  ref.read(audioProvider.notifier).onMode();
                },),),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.person),text: "Profile",onTap: (){},),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.key), text: "Change password", onTap: (){}),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.logout), text: "Log out", onTap: (){}),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.delete,), text: "Delete account", onTap: (){})
              ],
            ),
          ),
        );

  }
}
