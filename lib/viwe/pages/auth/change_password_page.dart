import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/button/custom_button.dart';

import '../../../controller/providers.dart';
import '../../../controller/user_controller/user_state.dart';
import '../../components/form_field/custom_text_form_field.dart';
import '../../components/style.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {

  TextEditingController password=TextEditingController();
 TextEditingController password2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserState watch=ref.watch(userProvider);
    final event=ref.read(userProvider.notifier);
    return BackGroundWidget(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
                children: [
                  30.verticalSpace,
                  Text("Change password",style: Style.boldText(),),
          200.verticalSpace,
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
          50.verticalSpace,
                  CustomButton(text: "OK", onTap: (){})
                ],
              ),
        ));
  }
}
