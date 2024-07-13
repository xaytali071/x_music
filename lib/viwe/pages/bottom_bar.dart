import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/audio_state/audio_state.dart';
import '../../controller/providers.dart';
import '../../controller/user_controller/user_state.dart';
import '../components/custom_network_image.dart';
import '../components/style.dart';
import 'home/dwower_widget.dart';
import 'home/home_page.dart';
import 'home/in_music_2.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}



class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  void initState() {
    selIndex = 0;
    super.initState();
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    UserState watch1 = ref.watch(userProvider);
    return Scaffold(
      key: _key,
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        drawer: DrawerWidget(dkey: _key, userInfo: watch1.userModel,),
        body: const HomePage(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: watch.selectIndex==null ? const SizedBox.shrink() : GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => InMusicPage(
                          music: watch.listOfMusic,
                          index: selIndex,
                        )));
          },
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 77.h,
              decoration: BoxDecoration(
                  gradient:
                      watch.darkMode ? Style.darkGradient : Style.gradient,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  CustomImageNetwork(
                    image: watch.listOfMusic[selIndex].artistData?.image ?? "",
                    height: 70,
                    width: 70,
                  ),
                  20.horizontalSpace,
                  Column(children: [
                    5.verticalSpace,
                    Text(
                      watch.listOfMusic[selIndex].trackName ?? "",
                      style: Style.miniText(),
                    ),
                    StreamBuilder(
                        stream: event.player.positionStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == event.player.duration) {
                            event
                              ..pause()
                              ..nextMusic(watch.listOfMusic[++selIndex])
                              ..getAudio(
                                  watch.listOfMusic[selIndex].trackUrl ?? "")
                              ..playy();
                            setState(() {});
                          }

                          return SizedBox(
                            width: 240.w,
                            child: ProgressBar(
                              timeLabelLocation: TimeLabelLocation.none,
                              progress:
                                  snapshot.data ?? const Duration(seconds: 0),
                              total: event.player.duration ??
                                  const Duration(seconds: 0),
                              onSeek: (duration) {
                                event.seek(duration);
                              },
                            ),
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              if (selIndex != 0) {
                                if (selIndex != 0) {
                                  event
                                    ..pause()
                                    ..pervous(
                                      watch.listOfMusic[--selIndex],
                                    )
                                    ..getAudio(await event.getAudioUrl(
                                        watch.listOfMusic[selIndex].trackUrl ??
                                            "") ?? "")
                                    ..playy();
                                  setState(() {});
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              size: 35,
                            )),
                        IconButton(
                            onPressed: () {
                              event.play();
                              !watch.isPlay ? event.playy() : event.pause();
                              setState(() {});
                            },
                            icon: watch.isPlay
                                ? const Icon(
                                    Icons.pause,
                                    size: 35,
                                  )
                                : const Icon(
                                    Icons.play_circle,
                                    size: 35,
                                  )),
                        IconButton(
                            onPressed: () async {
                              if (watch.listOfMusic.length - 1 != selIndex) {
                                event
                                  ..pause()
                                  ..nextMusic(watch.listOfMusic[++selIndex])
                                  ..getAudio(await event.getAudioUrl(
                                      watch.listOfMusic[selIndex].trackUrl ??
                                          "") ?? "")
                                  ..playy();
                                setState(() {});
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              size: 35,
                            )),
                      ],
                    )
                  ]),
                ]),
              )),
        ));
  }
}
