import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/components/image/avatar_image.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';
import 'package:xmusic/viwe/components/form_field/keyboard_dissimer.dart';
import 'package:xmusic/viwe/components/style.dart';

import '../bottom_bar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  TextEditingController name=TextEditingController();

  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((s){
     ref.read(userProvider.notifier).emptyName("");
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserState watch=ref.watch(userProvider);
    final event=ref.read(userProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
    return KeyboardDissimer(
      child: BackGroundWidget(
          child:Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(children: [
              30.verticalSpace,
                Text("Profile",style: Style.boldText(color:mode ? Style.primaryColor :Style.blackColor ),),
              30.verticalSpace,
              GestureDetector(
                  onTap: (){
                    event.getImageGallery((){});
                  },
                  child: AvatarImage(image:watch.imagePath=="" ? watch.userModel?.avatar ?? "" : watch.imagePath)),
              5.verticalSpace,
              
            watch.imagePath=="" ? const SizedBox.shrink() : watch.isLoading ? const CircularProgressIndicator() : GestureDetector(
                onTap: (){
                  event.editImage(onSuccess: (){
                  //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>BottomBar()), (_)=>false);
                  });
                },
                child: Text("Update image",style: Style.miniText(color: mode ? Style.primaryColor :Style.blackColor),)),
              30.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 260.w,
                      child: CustomTextFormField(hint: watch.userModel?.name ?? "",controller:name,onChanged: (a){
                        event.emptyName(a);
                      },)),
                   8.horizontalSpace,
                  watch.emptyName ? const SizedBox.shrink() : watch.isLoading ? const CircularProgressIndicator() :  GestureDetector(
                      onTap: (){
                        event.editName(name: name.text, onSuccess: (){
                          name.clear();
                        });
                      },
                      child: Text("Update name",style: Style.miniText(color: mode ? Style.primaryColor :Style.blackColor),))
                ],
              ),
              20.verticalSpace,
              Text(watch.userModel?.email ?? "",style: Style.normalText(color:mode ? Style.primaryColor :Style.blackColor ),),
              20.verticalSpace,
              Text(watch.userModel?.model ?? "",style: Style.normalText(color:mode ? Style.primaryColor :Style.blackColor ),),
      
            ],),
          ) ),
    );
  }
}
