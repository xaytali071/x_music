import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/viwe/components/style.dart';

class DrawerWidget extends StatelessWidget {
  final Key dkey;

  const DrawerWidget({super.key, required this.dkey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: state.darkMode ? Style.blackColor : Style.whiteColor,
          key: dkey,
          child: Column(
            children: [
              100.verticalSpace,
              Switch(value: state.darkMode, onChanged: (s) {
                context.read<AppCubit>().darkMode(s);
              })
            ],
          ),
        );
      },
    );
  }
}
