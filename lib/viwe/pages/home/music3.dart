import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';

import '../../../controller/aud/audio_cubit.dart';
import '../../../controller/aud/audio_state.dart';
import '../../../controller/audio_state/audio_cubit.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../../model/music_model.dart';
import '../../components/custom_network_image.dart';
import '../../components/style.dart';

class Music3 extends StatefulWidget {
  final String music;


  Music3({super.key, required this.music,});

  @override
  State<Music3> createState() => _Music3State();
}

class _Music3State extends State<Music3> {
  @override
  Duration? maxD;
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageNetwork(
                    image:  "",
                    width: 250,
                    height: 250,
                    radius: 16,
                  ),
                  10.verticalSpace,
                  Center(
                    child: Text(
                       "",
                      style: Style.normalText(
                          color: state.darkMode
                              ? Style.whiteColor
                              : Style.blackColor),
                    ),
                  ),
                  Center(
                    child: Text(
                       "",
                      style: Style.miniText(
                          color: state.darkMode
                              ? Style.whiteColor50
                              : Style.blackColor),
                    ),
                  ),
                  20.verticalSpace,
                  BlocBuilder<AudioCubit, AudioState>(
                    builder: (context, state) {
                      return StreamBuilder(
                          stream: context
                              .read<AudioCubit>()
                              .player
                              .positionStream,
                          builder: (context, snapshot) {
                            return BlocBuilder<AudioCubit, AudioState>(
                              builder: (context, state) {
                                return ProgressBar(
                                  progress: snapshot.data ??
                                      const Duration(seconds: 0),
                                  total: maxD ?? Duration(seconds: 0),
                                  onSeek: (duration) {
                                    context.read<AudioCubit>().player.seek(duration);
                                  },
                                );
                              },
                            );
                          });
                    },
                  ),
                  20.verticalSpace,
                  BlocBuilder<AudioCubit, AudioState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                            context.read<AudioCubit>().playy();
                              },
                              icon: const Icon(
                                Icons.skip_previous,
                                size: 40,
                              )),
                          IconButton(
                              onPressed: () {
                                !state.isPlay
                                    ? context
                                    .read<AudioCubit>()
                                    .playy()

                                    : context
                                    .read<AudioCubit>()
                                    .pause();

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

                              },
                              icon: const Icon(
                                Icons.skip_next,
                                size: 40,
                              )),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
