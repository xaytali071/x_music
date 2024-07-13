import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/aud/audio_cubit.dart';
import 'package:xmusic/controller/aud/audio_state.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/search_page.dart';

import '../../controller/audio_state/audio_cubit.dart';
import '../../controller/audio_state/audio_state.dart';
import '../../controller/providers.dart';

class TabWidget extends ConsumerWidget {
  const TabWidget({super.key});

  @override
  Widget build(BuildContext context,ref) {
    AppState watch=ref.watch(appProvider);
    final event=ref.read(appProvider.notifier);

        return Container(
          width: 150.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: watch.darkMode ? Style.whiteColor50 : Style.blackColor17,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: watch.darkMode ? Style.whiteColor50 : Style.blackColor17,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child:  Center(
                    child: Text("Network",style: Style.normalText(color: watch.darkMode ? Style.whiteColor : Style.blackColor50),)
                ),
              ),
              10.horizontalSpace,
              Center(
                            child: GestureDetector(
                                onTap: (){},
                                child:  Text("Search",style: Style.normalText(color: watch.darkMode ? Style.whiteColor50 : Style.blackColor50)))
                        )
            ],
          ),
        );

  }
}
