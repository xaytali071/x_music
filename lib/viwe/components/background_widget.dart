import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/dwower_widget.dart';

class BackGroundWidget extends ConsumerStatefulWidget {
  final Widget child;
  const BackGroundWidget({super.key, required this.child});

  @override
  ConsumerState<BackGroundWidget> createState() => _BackGroundWidgetState();
}

class _BackGroundWidgetState extends ConsumerState<BackGroundWidget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    AppState watch=ref.watch(appProvider);
    final event=ref.read(appProvider.notifier);
    UserState watch1=ref.watch(userProvider);
    return Scaffold(
      key: _key,
      endDrawerEnableOpenDragGesture: false,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget(dkey: _key, userInfo: watch1.userModel,),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration:  BoxDecoration(
            color: watch.darkMode ? Style.blackColor : Style.primaryColor,
              gradient: watch.darkMode ? const LinearGradient(
                begin: Alignment.topLeft,

                colors: [
                  Style.darkPrimaryColor,
                  Style.blackColor,

                ]
              ) : const LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                Style.primaryColor,
                Style.primaryColor,
                Style.whiteColor,
              ]),
          ),
          child:widget.child,
        )

      ),
    );
  }
}