import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/image/avatar_botton.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/form_field/keyboard_dissimer.dart';
import 'package:xmusic/viwe/pages/bottom_bar.dart';
import '../../../controller/providers.dart';
import '../../../controller/user_controller/user_state.dart';
import '../../components/button/custom_button.dart';
import '../../components/form_field/custom_text_form_field.dart';
import '../../components/button/mini_shadow_button.dart';
import '../../components/style.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController password2 = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserState watch=ref.watch(userProvider);
    final event=ref.read(userProvider.notifier);
    return KeyboardDissimer(
      child: BackGroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
                  children: [
                    50.verticalSpace,
                    Text(
                      "Sign up",
                      style: Style.boldText(color: Style.darkPrimaryColor),
                    ),
                    20.verticalSpace,
                    AvatarButton(
                      size: 90,
                    ),
                    40.verticalSpace,
                    CustomTextFormField(
                      hint: "Fullname",
                      controller: name,
                      onChanged: (s) {
                        event.changeName(name.text.isEmpty);
                      },
                      perfix: Icon(
                        Icons.person,
                        color: Style.darkPrimaryColor,
                      ),
                    ),
                    30.verticalSpace,
                    CustomTextFormField(
                      hint: "Email",
                      controller: email,
                      onChanged: (s) {
                        event
                            .changeEmail(email.text.isEmpty);
                      },
                      perfix: Icon(
                        Icons.email,
                        color: Style.darkPrimaryColor,
                      ),
                    ),
                    30.verticalSpace,
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
                    30.verticalSpace,
                    CustomTextFormField(
                      hint: "Confirm password",
                      obscure: watch.isHide,
                      controller: password2,
                      onChanged: (s) {
                        event
                            .checkConfirmPassword(s, password.text);
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
                    10.verticalSpace,
                    watch.errorText.isEmpty
                        ? const SizedBox.shrink()
                        : Text(
                            watch.errorText ?? "",
                            style: Style.normalText(color: Style.redColor),
                          ),
                    70.verticalSpace,
                    watch.check
                        ? CustomButton(
                            text: "Next",
                            onTap: () async {
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidInfo =
                                  await deviceInfo.androidInfo;
                              String? fcmToken =
                                  await FirebaseMessaging.instance.getToken();

                              watch.imagePath.isNotEmpty
                                  ? event.createImageUrl(
                                      imagePath: watch.imagePath,
                                      onSuccess: () {
                                        event.createUser(
                                            name: name.text,
                                            password: password.text,
                                            email: email.text,
                                            avatar: event.imgURl,
                                        fcm:fcmToken,
                                          model: "${androidInfo.board} ${androidInfo.model}"
                                        );
                                      })
                                  : event.createUser(
                                      name: name.text,
                                      password: password.text,
                                      email: email.text,
                                      avatar: "",
                                  fcm:fcmToken,
                                  model:  "${androidInfo.board} ${androidInfo.model}",
                              );
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );

                            },
                            color: Style.darkPrimaryColor,
                          )
                        : watch.isLoading ? const CircularProgressIndicator()  : CustomButton(
                            text: "Next",
                            onTap: () {
                              event
                                  .errorText("Name or email or password empty");
                            },
                            color: Style.primaryColor.withOpacity(0.5),
                          ),
                    30.verticalSpace,
                    Text(
                      "Or sign up With",
                      style: Style.normalText(color: Style.darkPrimaryColor),
                    ),
                    30.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MiniShadowButton(
                          image: "assets/Google.png",
                          onTap: () async {
                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            AndroidDeviceInfo androidInfo =
                                await deviceInfo.androidInfo;
                            String? fcmToken =
                                await FirebaseMessaging.instance.getToken();

                            event.registrGoogle(onSuccess:() {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );
                              }, fcm: fcmToken, model: "${androidInfo.board} ${androidInfo.model}");
                            },

                        ),
                        50.horizontalSpace,
                        MiniShadowButton(
                          image: "assets/Facebook.png",
                          onTap: () async {
                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                            AndroidDeviceInfo androidInfo =
                                await deviceInfo.androidInfo;
                            String? fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            event.reisterFacebook(fcm:fcmToken , model:  "${androidInfo.board} ${androidInfo.model}", onSuccess: (){
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );
                            });
                          },
                        )
                      ],
                    ),
                    40.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Alredy have an account ?",
                          style: Style.normalText(
                              color: Style.darkPrimaryColor,
                              weight: FontWeight.w600),
                        ),
                        8.horizontalSpace,
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign in",
                              style: Style.normalText(
                                  color: Style.darkPrimaryColor, size: 14),
                            ))
                      ],
                    ),
                    30.verticalSpace,
                  ],
                )

          ),
        ),
      ),
    );
  }
}
