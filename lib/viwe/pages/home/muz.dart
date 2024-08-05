import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/model/music_model.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../../controller/providers.dart';
import '../../components/image/custom_network_image.dart';
import '../../components/style.dart';
import 'home_page.dart';
import 'in_music_2.dart';


class
MuicWidget extends ConsumerStatefulWidget {
  final List<MusicModel> list;
  const MuicWidget({super.key, required this.list});

  @override
  ConsumerState<MuicWidget> createState() => _MuzState();
}

class _MuzState extends ConsumerState<MuicWidget> {
  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => InMusicPage(
                  music: widget.list,
                  index: selIndex,
                )));
      },
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 80.h,
          decoration: BoxDecoration(
              gradient: mode ? Style.darkGradient : Style.gradient,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              CustomImageNetwork(
                image: widget.list[selIndex].artistImage ?? "",
                height: 70,
                width: 70,
              ),
              20.horizontalSpace,
              Column(mainAxisSize: MainAxisSize.min, children: [
                //   5.verticalSpace,
                SizedBox(
                  width: MediaQuery.sizeOf(context).width-120,
                  child: Row(
                    children: [
                      Text(
                        widget.list[selIndex].trackName ?? "",
                        style: Style.miniText(),
                      ),
                      const Spacer(),
                      GestureDetector(onTap: (){
                        event.stop();
                        event.selectMusic(index: -1);
                      },child: Icon(Icons.cancel))
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: event.player.positionStream,
                    builder: (context, snapshot) {

                      if(snapshot.data==event.player.duration && event.player.duration!=null && widget.list.length - 1 != selIndex) {
                        selIndex++;
                        print("ishladi");
                        event.complaeteMusic(music: widget.list,
                            index: selIndex,
                            );
                      }
                      return SizedBox(
                        width: 240.w,
                        child: ProgressBar(
                          timeLabelLocation: TimeLabelLocation.none,
                          progress: snapshot.data ??
                              const Duration(seconds: 0),
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
                            event
                              ..pause()
                              ..pervous(
                                widget.list[--selIndex],
                              )
                              ..getAudio(widget.list[selIndex]
                                  .trackUrl ??
                                  "")
                              ..playy();
                            //   setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 35,
                        )),
                    IconButton(
                        onPressed: () {
                          event.play();
                          !watch.isPlay
                              ? event.playy()
                              : event.pause();
                          // setState(() {});
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
                          if (widget.list.length - 1 !=
                              selIndex) {
                            event
                              ..pause()
                              ..nextMusic(
                                widget.list[++selIndex],
                              )
                              ..getAudio(widget.list[selIndex]
                                  .trackUrl ??
                                  "")
                              ..playy();
                            // setState(() {});
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
    );
  }
}
