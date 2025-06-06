import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/button/custom_button.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';
import 'package:xmusic/viwe/components/form_field/keyboard_dissimer.dart';
import 'package:xmusic/viwe/components/button/mini_shadow_button.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/auth/sign_up_page.dart';
import 'package:xmusic/viwe/pages/bottom_bar.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s){
      ref.read(userProvider.notifier)
        ..changeName(false)
        ..checkConfirmPassword("12345678", "12345678")
        ..errorText("");
    });
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                    100.verticalSpace,
                    Text(
                      "Sign in",
                      style: Style.boldText(color: Style.darkPrimaryColor),
                    ),
                    50.verticalSpace,
                    CustomTextFormField(
                      hint: "Email",
                      controller: email,
                      onChanged: (s) {
                        event.changeEmail(s.isEmpty);
                      },
                      perfix: Icon(
                        Icons.email,
                        color: Style.darkPrimaryColor,
                      ),
                    ),
                    50.verticalSpace,
                    CustomTextFormField(
                      hint: "Password",
                      controller: password,
                      obscure: watch.isHide,
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
                    10.verticalSpace,
                    (watch.errorText.isEmpty)
                        ? SizedBox.shrink()
                        : Text(
                            watch.errorText ,
                            style: Style.normalText(color: Style.redColor),
                          ),
                    100.verticalSpace,
                    watch.check
                        ? CustomButton(
                            text: "Next",
                            onTap: () async {
                              String? fcmToken =
                                  await FirebaseMessaging.instance.getToken();
                              event
                                  .login(email: email.text,password: password.text,onSuccess:  () {
                                    event.updateFcm(fcmToken ?? "", (){
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );

                                    });

                              });
                            },
                            color: Style.darkPrimaryColor,
                          )
                        : watch.isLoading ? const CircularProgressIndicator() :CustomButton(
                            text: "Next",
                            onTap: () {
                              event
                                  .errorText("Email or password empty");
                            },
                            color: Style.primaryColor.withOpacity(0.5),
                          ),
                    30.verticalSpace,
                    Text(
                      "Or sign in With",
                      style: Style.normalText(color: Style.darkPrimaryColor),
                    ),
                    30.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MiniShadowButton(
                          image: "assets/Google.png",
                          onTap: () async {
                            String? fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            event.loginGoogle(onSuccess: (){
                              event.updateFcm(fcmToken ?? "", (){

                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );
                              });
                            });
                          },
                        ),
                        50.horizontalSpace,
                        MiniShadowButton(
                          image: "assets/Facebook.png",
                          onTap: () async {
                            String? fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            event.loginFacebook(onSuccess: (){
                              event.updateFcm(fcmToken ?? "", (){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()),(_)=>false );
                              });
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
                          "Don't have account ?",
                          style: Style.normalText(
                              color: Style.darkPrimaryColor,
                              weight: FontWeight.w600),
                        ),
                        8.horizontalSpace,
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignUpPage()));
                            },
                            child: Text(
                              "Sign up",
                              style: Style.normalText(
                                  color: Style.darkPrimaryColor, size: 14),
                            ))
                      ],
                    )
                  ],
                )

          ),
        ),
      ),
    );
  }
}
