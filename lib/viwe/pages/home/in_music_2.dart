import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';
import '../../../controller/audio_state/audio_cubit.dart';
import '../../../controller/audio_state/audio_state.dart';

class InMusicPage extends StatefulWidget {
  final List<MusicModel>? music;
  final BuildContext context;

  final int index;

  InMusicPage({
    super.key,
    required this.music,
    required this.index,
    required this.context,
  });

  @override
  State<InMusicPage> createState() => _InMusicPageState();
}

class _InMusicPageState extends State<InMusicPage> {
  @override
  void initState() {
    context.read<AudioCubit>().onMode();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
  builder: (context, state) {
    return Scaffold(
      backgroundColor: state.darkMode ? Style.blackColor : Style.whiteColor,
      body:Padding(
             padding: EdgeInsets.symmetric(horizontal: 20.w),
               child: Column(
                   children: [
                     100.verticalSpace,
                     CustomImageNetwork(
                       image: widget.music?[selIndex].artistData?.image ?? "",
                       width: 250,
                       height: 250,
                       radius: 16,
                     ),
                     10.verticalSpace,
                     Center(
                       child: Text(
                         widget.music?[selIndex].artistData?.name ?? "",
                         style: Style.normalText(
                             color: state.darkMode
                                 ? Style.whiteColor
                                 : Style.blackColor),
                       ),
                     ),
                     Center(
                       child: Text(
                         widget.music?[selIndex].trackName ?? "",
                         style: Style.miniText(
                             color: state.darkMode
                                 ? Style.whiteColor50
                                 : Style.blackColor),
                       ),
                     ),
                     20.verticalSpace,
                     StreamBuilder(
                         stream: widget.context
                             .read<AudioCubit>()
                             .player
                             .positionStream,
                         builder: (context, snapshot) {
                           if(snapshot.data==widget.context.read<AudioCubit>().player.duration && selIndex!=widget.music!.length-1){
                             widget.context.read<AudioCubit>()
                               ..pause()
                               ..nextMusic(
                                   widget.music![++selIndex])..getAudio(widget.music?[selIndex].trackUrl ?? "")..playy();
                             setState(() {});
                           }
                           return ProgressBar(
                             progress: snapshot.data ??
                                 const Duration(seconds: 0),
                             total: widget.context.read<AudioCubit>().player.duration ?? Duration(seconds: 0),
                             onSeek: (duration) {
                               widget.context
                                   .read<AudioCubit>().player.seek(duration);
                             },
                           );
                         }),
                     20.verticalSpace,
                          Row(
                           mainAxisAlignment:
                               MainAxisAlignment.spaceEvenly,
                           children: [
                             IconButton(onPressed: (){
                               widget.context.read<AudioCubit>().sielend();
                         }, icon: state.isSilent ? const Icon(Icons.volume_off) : const Icon(Icons.volume_up) ),
                             IconButton(
                                 onPressed: () {
                                   if (selIndex != 0) {
                                     widget.context.read<AudioCubit>()
                                       ..pause()
                                       ..pervous(
                                         widget.music![--selIndex],
                                       )
                                  ..getAudio(widget.music?[selIndex].trackUrl ?? "")..playy();
                                         setState(() {});
                                   }
                                 },
                                 icon: const Icon(
                                   Icons.skip_previous,
                                   size: 40,
                                 )),
                             IconButton(
                                 onPressed: () {
                                   context.read<AudioCubit>().play();
                                   state.isPlay
                                       ? widget.context
                                           .read<AudioCubit>()
                                           .playy()
                                       : widget.context
                                           .read<AudioCubit>()
                                           .pause();
                                   setState(() {});
                                 },
                                 icon: state.isPlay
                                     ? const Icon(
                                         Icons.pause,
                                         size: 60,
                                       )
                                     : const Icon(
                                         Icons.play_circle,
                                         size: 60,
                                       )),
                             IconButton(
                                 onPressed: () {
                                   if ((widget.music?.length ?? 0) - 1 !=
                                       selIndex) {
                                     widget.context.read<AudioCubit>()
                                       ..pause()
                                       ..nextMusic(
                                           widget.music![++selIndex])..getAudio(widget.music?[selIndex].trackUrl ?? "")..playy();
                                    setState(() {});
                                   }
                                 },
                                 icon: const Icon(
                                   Icons.skip_next,
                                   size: 40,
                                 )),
                               DropdownButton(
                                 value: state.speed,
                                 dropdownColor: state.darkMode ? Style.whiteColor50 : Style.blackColor50,
                                 style: Style.miniText(color:state.darkMode ? Style.blackColor50 : Style.whiteColor50),
                                 items: [
                                   DropdownMenuItem(
                                     value: 0.5,
                                     child: Text(
                                       "0.5x",
                                       style:Style.miniText(color:state.darkMode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 0.75,
                                     child: Text(
                                       "0.7x",
                                       style:Style.miniText(color: state.darkMode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 1.0,
                                     child: Text(
                                       "1.0x",
                                       style:Style.miniText(color: state.darkMode ? Style.blackColor50 : Style.whiteColor50),
                                     ),
                                   ),
                                   DropdownMenuItem(
                                     value: 1.5,
                                     child: Text("1.5x",
                                         style: Style.miniText(color: state.darkMode ? Style.blackColor50 : Style.whiteColor50)),
                                   ),
                                   DropdownMenuItem(
                                     value: 2.0,
                                     child: Text("2x",
                                         style: Style.miniText(color: state.darkMode ? Style.blackColor50 : Style.whiteColor50)),
                                   )
                                 ],
                                   onChanged: (s) {
                                     if (s != null) {
                                       widget.context.read<AudioCubit>().setSpeed(speed: s);
                                     }
                                   }
                               ),

                           ],
                         )

                   ],
                 )

           ),
    );
        },
      );

  }
}
