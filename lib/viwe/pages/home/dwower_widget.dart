import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/model/user_model.dart';
import 'package:xmusic/viwe/components/button/custom_social_button2.dart';
import 'package:xmusic/viwe/components/image/avatar_image.dart';
import 'package:xmusic/viwe/components/button/custom_button.dart';
import 'package:xmusic/viwe/components/button/custom_social_button.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/auth/change_password_page.dart';
import 'package:xmusic/viwe/pages/auth/profile_page.dart';
import 'package:xmusic/viwe/pages/auth/register_page.dart';

import '../../../controller/providers.dart';
import '../../components/form_field/custom_text_form_field.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  final Key dkey;
  final UserModel? userInfo;
  const DrawerWidget({super.key, required this.dkey, required this.userInfo});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {

  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context,) {
    UserState watch=ref.watch(userProvider);
    final event=ref.read(userProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
        return Drawer(
          backgroundColor: ref.watch(appProvider).darkMode ? Style.blackColor : Style.whiteColor,
          key: widget.dkey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                50.verticalSpace,
                AvatarImage(image: widget.userInfo?.avatar ?? ""),
                20.verticalSpace,
                SizedBox(
                    width: 250.w,
                    child: Text(widget.userInfo?.name ?? "",style: Style.normalText(color:mode ? Style.whiteColor : Style.blackColor,size: 14),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)),
                20.verticalSpace,
                CustomSocialButton2(leftIcon: const Icon(Icons.dark_mode), text: "Darkmode", onTap: (){},rightIcon: Switch(value: mode, onChanged: (bool value) {
                  ref.read(appProvider.notifier).darkMode(value);
                  ref.read(appProvider.notifier).darkMode(value);
                },),),
                20.verticalSpace,
                CustomSocialButton(leftIcon: const Icon(Icons.person),text: "Profile",onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>const ProfilePage()));
                },),
                20.verticalSpace,
                CustomSocialButton(leftIcon: const Icon(Icons.key), text: "Change password", onTap: (){
                  showDialog(context: context, builder: (_){
                   return Dialog(
                     backgroundColor: ref.watch(appProvider).darkMode ? Style.darkPrimaryColor :Style.primaryColor,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            20.verticalSpace,
                            Text("Entr password",style: Style.normalText(),),
                            20.verticalSpace,
                            CustomTextFormField(
                              hint: "Password",
                              obscure: watch.isHide,
                              controller: password,
                              onChanged: (s) {
                                event.checkPassword(s);
                              },
                              perfix: const Icon(
                                Icons.lock,
                                color: Style.darkPrimaryColor,
                              ),
                              sufix: GestureDetector(
                                  onTap: () {
                                    event.hidePassword();
                                  },
                                  child: watch.isHide
                                      ? const Icon(
                                    Icons.visibility,
                                    color: Style.darkPrimaryColor,
                                  )
                                      : const Icon(
                                    Icons.visibility_off,
                                    color: Style.darkPrimaryColor,
                                  )),
                            ),
                            20.verticalSpace,
                            CustomButton(text: "Next", onTap: (){
                              if(watch.userModel?.password==password.text){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>ChangePasswordPage()));
                              }
                            }),
                            20.verticalSpace,
                          ],
                        ),
                      ),
                    );
                  });
                }),
                20.verticalSpace,
                CustomSocialButton(leftIcon: Icon(Icons.logout), text: "Log out", onTap: (){
                  showDialog(context: context, builder: (_){
                    return Dialog(
                      backgroundColor: ref.watch(appProvider).darkMode ? Style.darkPrimaryColor :Style.primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Do you want to log out?",style: Style.normalText(),),
                        20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomButton(
                                  width: 70,
                                  height: 30,
                                  text: "Yes", onTap: (){
                                ref.read(userProvider.notifier).logOut((){
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const RegisterPage()), (_)=>false);
                                });
                              }),
                              CustomButton(
                                  width: 70,
                                  height: 30,
                                  text: "No", onTap: (){
                                Navigator.pop(context);
                              })
                            ],
                          ),
                          20.verticalSpace,
                        ],

                      ),
                    );
                  });
                }),
                20.verticalSpace,
                CustomSocialButton(leftIcon: const Icon(Icons.delete,), text: "Delete account", onTap: (){
                  showDialog(context: context, builder: (_){
                    return Dialog(
                      backgroundColor: ref.watch(appProvider).darkMode ? Style.darkPrimaryColor :Style.primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Do you want to delete your account?",style: Style.normalText(),),
                          20.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomButton(
                                  width: 70,
                                  height: 30,
                                  text: "Yes", onTap: (){
                                ref.read(userProvider.notifier).deleteAccount((){
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const RegisterPage()), (_)=>false);
                                });
                              }),
                              CustomButton(
                                  width: 70,
                                  height: 30,
                                  text: "No", onTap: (){
                                Navigator.pop(context);
                              })
                            ],
                          ),
                          20.verticalSpace
                        ],

                      ),
                    );
                  });
                })
              ],
            ),
          ),
        );

  }
}
