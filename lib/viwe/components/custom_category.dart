import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/music_by_artist.dart';

import '../../model/author_model.dart';

class Category extends StatelessWidget {
  final List<AuthorModel> list;
  const Category({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
  builder: (context, state) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (_)=>BlocProvider(
  create: (context) => AudioCubit(),
  child: MusicByArtist(data: list[index], context: context,),
)));
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:state.darkMode ? Style.whiteColor50 : Style.blackColor17,
                    borderRadius: BorderRadius.circular(8.r)
                  ), child:Center(child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(list[index].name ?? "",style: Style.normalText(size: 9,color: state.darkMode ? Style.whiteColor : Style.blackColor),),
                  )),
                ),
              ),
            );
          }),
    );
  },
);
  }
}
