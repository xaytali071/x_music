import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/aud/audio_cubit.dart';
import 'package:xmusic/controller/aud/audio_state.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/search_page.dart';

import '../../controller/audio_state/audio_cubit.dart';
import '../../controller/audio_state/audio_state.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String path="";
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        context.read<AppCubit>().getMode();
        return Container(
          width: 150.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: state.darkMode ? Style.whiteColor50 : Style.blackColor17,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: state.darkMode ? Style.whiteColor50 : Style.blackColor17,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child:  Center(
                    child: Text("Network",style: Style.normalText(color: state.darkMode ? Style.whiteColor : Style.blackColor50),)
                ),
              ),
              10.horizontalSpace,
              BlocBuilder<AudioCubit, AudioState>(
  builder: (context, state) {
    return Center(
                  child: GestureDetector(
                      onTap: (){},
                      child:  Text("Search",style: Style.normalText(color: state.darkMode ? Style.whiteColor50 : Style.blackColor50)))
              );
  },
)
            ],
          ),
        );
      },
    );
  }
}
