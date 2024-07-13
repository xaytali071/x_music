import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/avatar_botton.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/keyboard_dissimer.dart';
import '../../../controller/providers.dart';
import '../../../controller/user_controller/user_state.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/mini_shadow_button.dart';
import '../../components/style.dart';
import '../home/home_page.dart';

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
                    (watch.errorText?.isEmpty ?? false)
                        ? SizedBox.shrink()
                        : Text(
                            watch.errorText ?? "",
                            style: Style.normalText(color: Style.redColor),
                          ),
                    70.verticalSpace,
                    watch.check
                        ? CustomButton(
                            text: "Next",
                            onTap: () {
                              (watch.imagePath?.isNotEmpty ?? false)
                                  ? event.createImageUrl(
                                      imagePath: watch.imagePath ?? "",
                                      onSuccess: () {
                                        event.createUser(
                                            name: name.text,
                                            password: password.text,
                                            email: email.text,
                                            avatar: watch.imageUrl);
                                      })
                                  : event.createUser(
                                      name: name.text,
                                      password: password.text,
                                      email: email.text,
                                      avatar: "");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                            },
                            color: Style.darkPrimaryColor,
                          )
                        : watch.isLoading ? CircularProgressIndicator()  : CustomButton(
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
                          onTap: () {
                            event.loginGoogle(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomePage()));
                            });
                          },
                        ),
                        50.horizontalSpace,
                        MiniShadowButton(
                          image: "assets/Facebook.png",
                          onTap: () {},
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
