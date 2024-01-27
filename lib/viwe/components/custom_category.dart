import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/viwe/components/style.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list=["afsgsg","sdfgdshgdfbdfg","sgsgfsdg","sdgfsgsrg","gdsfgs"];
    return BlocBuilder<AppCubit, AppState>(
  builder: (context, state) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:state.darkMode ? Style.whiteColor50 : Style.blackColor17,
                  borderRadius: BorderRadius.circular(8.r)
                ), child:Center(child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(list[index],style: Style.normalText(size: 9,color: state.darkMode ? Style.whiteColor : Style.blackColor),),
                )),
              ),
            );
          }),
    );
  },
);
  }
}
