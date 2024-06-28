import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/model/author_model.dart';

import '../../../controller/app_controller/app_cubit.dart';
import '../../../controller/audio_state/audio_cubit.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../components/button_effect.dart';
import '../../components/custom_network_image.dart';
import '../../components/style.dart';
import 'home_page.dart';
import 'in_music_2.dart';

class MusicByArtist extends StatefulWidget {
  final AuthorModel data;
  final BuildContext context;
  const MusicByArtist({super.key, required this.data, required this.context,});

  @override
  State<MusicByArtist> createState() => _MusicByArtistState();
}

class _MusicByArtistState extends State<MusicByArtist> {

  @override
  void initState() {
WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  // context.read<AudioCubit>().getMusicByArtist(docId: widget.data.id ?? "", name: widget.data.name ?? "");
});
print(widget.data.id);
print(widget.data.name);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AudioCubit, AudioState>(
  builder: (context, state) {
    return Column(
        children: [
          if (state.isLoading) const Center(child: CircularProgressIndicator()) else ListView.builder(
              itemCount: state.listOfMusicArtist?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // widget.context.read<AudioCubit>().addBannerMusic(state.listOfMusic![index],index);
                    selIndex = index;
                    widget.context.read<AudioCubit>()
                      ..onMode()
                      ..getAudio(
                          state.listOfMusicArtist?[index].trackUrl ??
                              "")
                      ..playy();

                    showBottomSheet(
                        context: context,
                        builder: (_) {
                          return DraggableScrollableSheet(
                              minChildSize: 0.12,
                              maxChildSize: 0.5,
                              initialChildSize: 0.12,
                              expand: false,
                              builder: (context, controller) {
                                return BlocBuilder<AudioCubit,
                                    AudioState>(
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider(
                                                            create: (context) =>
                                                                AudioCubit(),
                                                          ),
                                                          BlocProvider(
                                                            create: (context) =>
                                                                AppCubit(),
                                                          ),
                                                        ],
                                                        child:
                                                        InMusicPage(
                                                          music: state
                                                              .listOfMusicArtist ??
                                                              [],
                                                          index:
                                                          selIndex,
                                                          context:
                                                          widget.context,
                                                        ),
                                                      )));
                                        },
                                        child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: 200.h,
                                            decoration: BoxDecoration(
                                                gradient: state.darkMode
                                                    ? Style
                                                    .darkGradient
                                                    : Style.gradient,
                                                borderRadius:
                                                BorderRadius.only(
                                                    topRight: Radius
                                                        .circular(
                                                        20.r),
                                                    topLeft: Radius
                                                        .circular(
                                                        20.r))),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  CustomImageNetwork(
                                                    image: state
                                                        .listOfMusicArtist?[
                                                    selIndex]
                                                        .artistData
                                                        ?.image ??
                                                        "",
                                                    height: 70,
                                                    width: 70,
                                                  ),
                                                  20.horizontalSpace,
                                                  Column(children: [
                                                    5.verticalSpace,
                                                    Text(
                                                      state
                                                          .listOfMusicArtist?[
                                                      selIndex]
                                                          .trackName ??
                                                          "",
                                                      style: Style
                                                          .miniText(),
                                                    ),
                                                    BlocBuilder<
                                                        AudioCubit,
                                                        AudioState>(
                                                      builder:
                                                          (context,
                                                          state) {
                                                        return StreamBuilder(
                                                            stream: widget.context
                                                                .read<
                                                                AudioCubit>()
                                                                .player
                                                                .positionStream,

                                                            builder:
                                                                (context,
                                                                snapshot) {
                                                              if(snapshot.data==widget.context.read<AudioCubit>().player.duration && selIndex!=state.listOfMusicArtist!.length-1){
                                                                widget.context.read<AudioCubit>()
                                                                  ..pause()
                                                                  ..nextMusic(
                                                                      state.listOfMusicArtist![++selIndex])..getAudio(state.listOfMusicArtist
                                                                ?[selIndex].trackUrl ?? "")..playy();
                                                                setState(() {});
                                                              }
                                                              return BlocBuilder<
                                                                  AudioCubit,
                                                                  AudioState>(
                                                                builder:
                                                                    (context, state) {
                                                                  return SizedBox(
                                                                    width: 240.w,
                                                                    child: ProgressBar(
                                                                      timeLabelLocation: TimeLabelLocation.none,
                                                                      progress: snapshot.data ?? const Duration(seconds: 0),
                                                                      total: widget.context.read<AudioCubit>().player.duration ?? const Duration(seconds: 0),
                                                                      onSeek: (duration) {
                                                                        widget.context.read<AudioCubit>().seek(duration);
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            });
                                                      },
                                                    ),
                                                    BlocBuilder<
                                                        AudioCubit,
                                                        AudioState>(
                                                        builder:
                                                            (context,
                                                            state) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (index !=
                                                                        0) {
                                                                      widget.context.read<AudioCubit>()
                                                                        ..pause()
                                                                        ..pervous(
                                                                          state.listOfMusicArtist![--selIndex],
                                                                        )
                                                                        ..getAudio(state.listOfMusicArtist?[selIndex].trackUrl ?? "");
                                                                    }
                                                                  },
                                                                  icon:
                                                                  const Icon(
                                                                    Icons
                                                                        .skip_previous,
                                                                    size:
                                                                    35,
                                                                  )),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    widget.context
                                                                        .read<AudioCubit>()
                                                                        .play();
                                                                    state.isPlay
                                                                        ? widget.context.read<AudioCubit>().playy()
                                                                        : widget.context.read<AudioCubit>().pause();
                                                                  },
                                                                  icon: state.isPlay
                                                                      ? const Icon(
                                                                    Icons.pause,
                                                                    size: 35,
                                                                  )
                                                                      : const Icon(
                                                                    Icons.play_circle,
                                                                    size: 35,
                                                                  )),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if ((state.listOfMusicArtist?.length ?? 0) - 1 !=
                                                                        index) {
                                                                      widget.context.read<AudioCubit>()
                                                                        ..pause()
                                                                        ..nextMusic(state.listOfMusicArtist![++selIndex])
                                                                        ..getAudio(state.listOfMusicArtist?[selIndex].trackUrl ?? "");
                                                                    }
                                                                  },
                                                                  icon:
                                                                  const Icon(
                                                                    Icons
                                                                        .skip_next,
                                                                    size:
                                                                    35,
                                                                  )),
                                                            ],
                                                          );
                                                        })
                                                  ])
                                                ],
                                              ),
                                            )),
                                      );
                                    });
                              });
                        });
                  },
                  child: BlocBuilder<AudioCubit, AudioState>(
                    builder: (context, state) {
                      return AnimationButtonEffect(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          width: MediaQuery.sizeOf(widget.context).width,
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(12.r),
                            color: const Color(0xFFDAD4EC)
                                .withOpacity(0.2),
                          ),
                          child: Row(
                            children: [
                              CustomImageNetwork(
                                  image: state.listOfMusicArtist?[index]
                                      .artistData?.image ??
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
                                        state
                                            .listOfMusicArtist?[
                                        index]
                                            .artistData
                                            ?.name ??
                                            "",
                                        style: Style.normalText(
                                            color: state.darkMode
                                                ? Style
                                                .whiteColor50
                                                : Style
                                                .blackColor),
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                  SizedBox(
                                      width: 250.w,
                                      child: Text(
                                        state.listOfMusicArtist?[index]
                                            .trackName ??
                                            "",
                                        style: Style.miniText(
                                            color: state.darkMode
                                                ? Style
                                                .whiteColor50
                                                : Style
                                                .blackColor),
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      );
  },
),
    );
  }
}
