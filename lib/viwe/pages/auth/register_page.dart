import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/custom_button.dart';
import 'package:xmusic/viwe/components/custom_text_form_field.dart';
import 'package:xmusic/viwe/components/keyboard_dissimer.dart';
import 'package:xmusic/viwe/components/mini_shadow_button.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/auth/sign_up_page.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    context.read<UserCubit>()
      ..changeName(false)
      ..checkConfirmPassword("12345678", "12345678")
      ..errorText("");
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                        context.read<UserCubit>().changeEmail(s.isEmpty);
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
                      obscure: state.isHide,
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
                    10.verticalSpace,
                    (state.errorText?.isEmpty ?? false)
                        ? SizedBox.shrink()
                        : Text(
                            state.errorText ?? "",
                            style: Style.normalText(color: Style.redColor),
                          ),
                    100.verticalSpace,
                    state.check
                        ? CustomButton(
                            text: "Next",
                            onTap: () {
                              context
                                  .read<UserCubit>()
                                  .login(email: email.text,password: password.text,onSuccess:  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) =>
                                                      AppCubit(),
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
                            color: Style.darkPrimaryColor,
                          )
                        : state.isLoading ? CircularProgressIndicator() :CustomButton(
                            text: "Next",
                            onTap: () {
                              context
                                  .read<UserCubit>()
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
                          onTap: () {},
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
                                      builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                create: (context) =>
                                                    UserCubit(),
                                              ),
                                              BlocProvider(
                                                create: (context) => AppCubit(),
                                              ),
                                            ],
                                            child: SignUpPage(),
                                          )));
                            },
                            child: Text(
                              "Sign up",
                              style: Style.normalText(
                                  color: Style.darkPrimaryColor, size: 14),
                            ))
                      ],
                    )
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
