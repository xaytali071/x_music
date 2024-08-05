import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/button/custom_button.dart';
import 'package:xmusic/viwe/components/image/custom_network_image.dart';
import 'package:xmusic/viwe/components/send_rating.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../../controller/providers.dart';
import '../../components/rating_bar.dart';

class InMusicPage extends ConsumerStatefulWidget {
  final List<MusicModel> music;
 // final BuildContext context;

  final int index;

  const InMusicPage({
    super.key,
    required this.music,
    required this.index,
    //required this.context,
  });

  @override
  ConsumerState<InMusicPage> createState() => _InMusicPageState();
}

class _InMusicPageState extends ConsumerState<InMusicPage> {

  int rating=0;
  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  @override
  void initState() {
    print(selIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
    return BackGroundWidget(
      child:Padding(
             padding: EdgeInsets.symmetric(horizontal: 20.w),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                   children: [
                     100.verticalSpace,
                     CustomImageNetwork(
                       image: widget.music[selIndex].artistImage ?? "",
                       width: 250,
                       height: 250,
                       radius: 16,
                     ),
                     10.verticalSpace,
                     Center(
                       child: Text(
                         widget.music[selIndex].artistName ?? "",
                         style: Style.normalText(
                             color: mode
                                 ? Style.whiteColor
                                 : Style.blackColor),
                       ),
                     ),
                     Center(
                       child: Text(
                         widget.music[selIndex].trackName ?? "",
                         style: Style.miniText(
                             color: mode
                                 ? Style.whiteColor50
                                 : Style.blackColor),
                       ),
                     ),
                     20.verticalSpace,
                     StreamBuilder(
                         stream: event
                             .player
                             .positionStream,
                         builder: (context, snapshot) {
                           if(snapshot.data==event.player.duration && event.player.duration!=null && widget.music.length - 1 != selIndex) {
                             print("ishladi");
                             selIndex++;
                             event.complaeteMusic(music: widget.music,
                                 index: selIndex,
                                 );
                           }
                           return ProgressBar(
                             progress: snapshot.data ??
                                 const Duration(seconds: 0),
                             total: event.player.duration ?? const Duration(seconds: 0),
                             onSeek: (duration) {
                               event.player.seek(duration);
                             },
                           );
                         }),
                    // 20.verticalSpace,
                    //  SizedBox(
                    //    height: 40.h,
                    //    child: MusicVisualizer(
                    //      barCount: 30,
                    //      colors: colors,
                    //      duration: duration,
                    //
                    //    ),
                    //  ),
                          20.verticalSpace,
                          Row(
                           mainAxisAlignment:
                               MainAxisAlignment.spaceEvenly,
                           children: [
                             IconButton(onPressed: (){
                               event.sielend();
                         }, icon: watch.isSilent ? const Icon(Icons.volume_off) : const Icon(Icons.volume_up) ),
                             IconButton(
                                 onPressed: () async {
                                   if (selIndex != 0) {
                                     event
                                       ..pause()
                                       ..pervous(
                                         widget.music[--selIndex],
                                       )
                                  ..getAudio(watch.listOfMusic[selIndex].trackUrl ?? "")..playy();
                                     //    setState(() {});
                                   }
                                 },
                                 icon: const Icon(
                                   Icons.skip_previous,
                                   size: 40,
                                 )),
                             IconButton(
                                 onPressed: () {
                                   event.play();
                                   !watch.isPlay
                                       ? event
                                           .playy()
                                       : event
                                           .pause();
                                  // setState(() {});
                                 },
                                 icon: watch.isPlay
                                     ? const Icon(
                                         Icons.pause,
                                         size: 60,
                                       )
                                     : const Icon(
                                         Icons.play_circle,
                                         size: 60,
                                       )),
                             IconButton(
                                 onPressed: () async {
                                   if (widget.music.length - 1 != selIndex) {
                                     event
                                       ..pause()
                                       ..nextMusic(
                                           widget.music[selIndex])..getAudio(watch.listOfMusic[++selIndex].trackUrl ?? "")..playy();
                                   // setState(() {});
                                   }
                                 },
                                 icon: const Icon(
                                   Icons.skip_next,
                                   size: 40,
                                 )),
                               DropdownButton(
                                 value: watch.speed,
                                 dropdownColor: mode ? Style.whiteColor50 : Style.blackColor50,
                                 style: Style.miniText(color:mode ? Style.blackColor50 : Style.whiteColor50),
                                 items: [
                                   DropdownMenuItem(
                                     value: 0.5,
                                     child: Text(
                                       "0.5x",
                                       style:Style.miniText(color:mode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 0.75,
                                     child: Text(
                                       "0.7x",
                                       style:Style.miniText(color: mode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 1.0,
                                     child: Text(
                                       "1.0x",
                                       style:Style.miniText(color: mode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 1.5,
                                     child: Text("1.5x",
                                         style: Style.miniText(color: mode ? Style.blackColor50 : Style.whiteColor50)),
                                   ),
                                   DropdownMenuItem(
                                     value: 2.0,
                                     child: Text("2x",
                                         style: Style.miniText(color: mode ? Style.blackColor50 : Style.whiteColor50)),
                                   )
                                 ],
                                   onChanged: (s) {
                                     if (s != null) {
                                       event.setSpeed(speed: s);
                                     }
                                   }
                               ),

                           ],
                         ),
                      20.verticalSpace,
                     CustomRatingBar(rating: widget.music[selIndex].rating?.toDouble() ?? 0 / (widget.music[selIndex].userIdList?.length ?? 0),size: 25,),

                     20.verticalSpace,
                     CustomButton(text: "Rating", onTap: (){
                       showModalBottomSheet(
                           backgroundColor: Style.transperntColor,
                           context: context, builder: (_){
                         return SendRating(movie:widget.music[selIndex] , docId: widget.music[selIndex].id ?? "");
                       });
                     }),


                   ],
                 )

           ),
    );

  }

}
