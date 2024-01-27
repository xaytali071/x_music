import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/viwe/pages/home/dwower_widget.dart';

class BackGroundWidget extends StatefulWidget {
  final Widget child;
  const BackGroundWidget({super.key, required this.child});

  @override
  State<BackGroundWidget> createState() => _BackGroundWidgetState();
}

class _BackGroundWidgetState extends State<BackGroundWidget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      endDrawerEnableOpenDragGesture: false,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget(dkey: _key,),
      body: SingleChildScrollView(
        child: BlocBuilder<AppCubit, AppState>(
  builder: (context, state) {
    return Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration:  BoxDecoration(
              image: DecorationImage(
                  image: state.darkMode ? const AssetImage("assets/BackgroundDark.png",) : const AssetImage("assets/Background.png"),
                  fit: BoxFit.cover
              )
          ),
          child:widget.child,
        );
  },
),
      ),
    );
  }
}