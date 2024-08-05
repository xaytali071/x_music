import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/background_widget.dart';

import '../../../controller/audio_state/audio_state.dart';
import '../../../controller/providers.dart';
import '../../components/button/button_effect.dart';
import '../../components/image/custom_network_image.dart';
import '../../components/style.dart';
import 'home_page.dart';

class MusicByGanre extends ConsumerStatefulWidget {
  final String name;
  const MusicByGanre({super.key,required this.name, });

  @override
  ConsumerState<MusicByGanre> createState() => _MusicByArtistState();
}

class _MusicByArtistState extends ConsumerState<MusicByGanre> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((d){
        ref.read(audioProvider.notifier).searchMusicbyGanre(name: widget.name);

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final event=ref.read(audioProvider.notifier);
    AudioState watch=ref.watch(audioProvider);
    bool mode=ref.watch(appProvider).darkMode;
    return BackGroundWidget(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: watch.listOfSearchRes.length,
                itemBuilder: (context,index){
                  return InkWell(
                      onTap: ()  {
                        selIndex = index;
                        event..selectMusic(index: index)..isSearchList(true);
                        Future.delayed(Duration(milliseconds: 700)).then((s){
                          event
                            ..getAudio(watch.listOfSearchRes[index].trackUrl ?? "")
                            ..playy();

                        });

                      },
                      child: AnimationButtonEffect(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          width: MediaQuery.sizeOf(context).width,
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color:
                            const Color(0xFFDAD4EC).withOpacity(0.2),
                          ),
                          child: Row(
                            children: [
                              CustomImageNetwork(
                                  image:  watch.listOfSearchRes[index].artistImage ??
                                      "",
                                  width: 80,
                                  height: 80),
                              10.horizontalSpace,
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        watch.listOfSearchRes[index].artistName ??
                                            "",
                                        style: Style.normalText(
                                            color: mode
                                                ? Style.whiteColor50
                                                : Style.blackColor),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                  SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        watch.listOfSearchRes[index]
                                            .trackName ??
                                            "",
                                        style: Style.miniText(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
