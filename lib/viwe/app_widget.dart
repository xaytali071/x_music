import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/aud/audio_cubit.dart';
import 'package:xmusic/controller/localStore/local_store.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/viwe/pages/auth/register_page.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';

import '../controller/audio_state/audio_cubit.dart';


class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {


  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed){
      if(!isAllowed){
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MultiBlocProvider(
              providers: [
              BlocProvider(create: (_)=>AudioCubit()),
                BlocProvider(create: (_)=>AppCubit()),
                BlocProvider(create: (_)=>UserCubit()),
              ],
              child: LocaleStore.getId()==null ? HomePage() : HomePage(),
            ),
          );
        }
    );
  }
}