import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/music_by_artist.dart';
import 'package:xmusic/viwe/pages/home/music_by_ganre.dart';

import '../../controller/providers.dart';
import '../../model/author_model.dart';

class Category extends ConsumerWidget {
  final List<String> list;
  const Category({super.key, required this.list});

  @override
  Widget build(BuildContext context,ref) {
    AppState watch=ref.watch(appProvider);
    final event=ref.read(appProvider.notifier);
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
                  Navigator.push(context,MaterialPageRoute(builder: (_)=>MusicByGanre(name: list[index],)));
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:watch.darkMode ? Style.whiteColor50 : Style.blackColor17,
                    borderRadius: BorderRadius.circular(8.r)
                  ), child:Center(child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(list[index],style: Style.normalText(size: 9,color: watch.darkMode ? Style.whiteColor : Style.blackColor),),
                  )),
                ),
              ),
            );
          }),
    );
  }
}
