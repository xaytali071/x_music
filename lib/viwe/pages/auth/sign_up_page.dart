import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/avatar_botton.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/keyboard_dissimer.dart';

import '../../../controller/app_controller/app_cubit.dart';
import '../../../controller/audio_state/audio_cubit.dart';
import '../../../controller/user_controller/user_cubit.dart';
import '../../../controller/user_controller/user_state.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_form_field.dart';
import '../../components/mini_shadow_button.dart';
import '../../components/style.dart';
import '../home/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController password2 = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardDissimer(
      child: BackGroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return Column(
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
                        context.read<UserCubit>().changeName(name.text.isEmpty);
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
                        context
                            .read<UserCubit>()
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
                      obscure: state.isHide,
                      controller: password,
                      onChanged: (s) {
                        context.read<UserCubit>().checkPassword(s);
                      },
                      perfix: const Icon(
                        Icons.lock,
                        color: Style.darkPrimaryColor,
                      ),
                      sufix: GestureDetector(
                          onTap: () {
                            context.read<UserCubit>().hidePassword();
                          },
                          child: state.isHide
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
                      obscure: state.isHide,
                      controller: password2,
                      onChanged: (s) {
                        context
                            .read<UserCubit>()
                            .checkConfirmPassword(s, password.text);
                      },
                      perfix: const Icon(
                        Icons.lock,
                        color: Style.darkPrimaryColor,
                      ),
                      sufix: GestureDetector(
                          onTap: () {
                            context.read<UserCubit>().hidePassword();
                          },
                          child: state.isHide
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
                    (state.errorText?.isEmpty ?? false)
                        ? SizedBox.shrink()
                        : Text(
                            state.errorText ?? "",
                            style: Style.normalText(color: Style.redColor),
                          ),
                    70.verticalSpace,
                    state.check
                        ? CustomButton(
                            text: "Next",
                            onTap: () {
                              (state.imagePath?.isNotEmpty ?? false)
                                  ? context.read<UserCubit>().createImageUrl(
                                      imagePath: state.imagePath ?? "",
                                      onSuccess: () {
                                        context.read<UserCubit>().createUser(
                                            name: name.text,
                                            password: password.text,
                                            email: email.text,
                                            avatar: state.imageUrl);
                                      })
                                  : context.read<UserCubit>().createUser(
                                      name: name.text,
                                      password: password.text,
                                      email: email.text,
                                      avatar: "");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                create: (context) => AppCubit(),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    AudioCubit(),
                                              ),
                                            ],
                                            child: HomePage(),
                                          )));
                            },
                            color: Style.darkPrimaryColor,
                          )
                        : state.isLoading ? CircularProgressIndicator()  : CustomButton(
                            text: "Next",
                            onTap: () {
                              context
                                  .read<UserCubit>()
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
                            context.read<UserCubit>().loginGoogle(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                create: (context) => AppCubit(),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    AudioCubit(),
                                              ),
                                            ],
                                            child: HomePage(),
                                          )));
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
