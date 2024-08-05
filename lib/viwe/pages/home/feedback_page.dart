import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/local_store.dart';
import 'package:xmusic/viwe/components/button/custom_button.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';
import 'package:xmusic/viwe/components/form_field/keyboard_dissimer.dart';
import 'package:xmusic/viwe/components/style.dart';

import '../../../controller/providers.dart';
import '../../../controller/user_controller/user_state.dart';
import '../../components/background_widget.dart';

class FeedBackPage extends ConsumerStatefulWidget {
  const FeedBackPage({super.key});

  @override
  ConsumerState<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends ConsumerState<FeedBackPage> {
  TextEditingController text=TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserState watch=ref.watch(userProvider);
    final event=ref.read(userProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
    return KeyboardDissimer(
      child: BackGroundWidget(
        child:Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              50.verticalSpace,
              Text("Feedback",style: Style.boldText(color: mode ? Style.primaryColor : Style.blackColor),),
              100.verticalSpace,
              CustomTextFormField(hint: "Message",controller: text,maxLines: 20,height: 200,borderColor: Style.blackColor17,),
            50.verticalSpace,
            watch.isLoading ? CircularProgressIndicator() : CustomButton(text: "Send", onTap: (){
              event.sendFeedback(title: text.text);
              text.clear();
              })
            ],
          ),
        )
      ),
    );
  }
}
