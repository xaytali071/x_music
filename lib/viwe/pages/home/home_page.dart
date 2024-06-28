import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/add/HomePage2.dart';
import 'package:xmusic/viwe/add/add_page.dart';
import 'package:xmusic/viwe/components/avatar_image.dart';
import 'package:xmusic/viwe/components/background_widget.dart';

import 'package:xmusic/viwe/components/button_effect.dart';
import 'package:xmusic/viwe/components/custom_category.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/components/tab_widget.dart';
import 'package:xmusic/viwe/pages/home/in_music_2.dart';
import '../../../controller/audio_state/audio_cubit.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../components/custom_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selIndex = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AudioCubit>().fechMusic(page: 1);
      context.read<AppCubit>().getMode();
      context.read<UserCubit>().getUser();
      context.read<AudioCubit>().getArtist();
    });
    refreshController=RefreshController();
    super.initState();
  }

  notification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: "music",
          body: "Music",
          title: "music",
          notificationLayout: NotificationLayout.Messaging),
      actionButtons: [
        NotificationActionButton(
            key: "next", label: "Next", actionType: ActionType.KeepOnTop),
      ],
    );
  }

  int page=2;
  late RefreshController refreshController;

  @override
  void dispose() {
refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackGroundWidget(
        child: SafeArea(
      child: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: ()async{
          context.read<AudioCubit>().getMusic();
          refreshController.refreshCompleted();
        },
        onLoading: (){
           context.read<AudioCubit>().fechMusic(page: page++);
           refreshController.loadComplete();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: BlocBuilder<AudioCubit, AudioState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: const Icon(Icons.menu)),
                            Text(
                              "XMusic",
                              style: Style.boldText(),
                            ),
                            const Spacer(),
                            BlocBuilder<UserCubit, UserState>(
                              builder: (context, state) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                    create: (context) =>
                                                        AudioCubit(),
                                                    child: HomePage2(),
                                                  )));
                                    },
                                    child: AvatarImage(
                                      image: state.userModel?.avatar ?? "",
                                      size: 30,
                                    ));
                              },
                            )
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      const TabWidget(),
                      10.verticalSpace,
                       Category(list: state.listOfAuthor ?? [],),
                      10.verticalSpace,
                      // BannerWidget(list: state.listOfBanner ?? [],),
                      10.verticalSpace,
                      state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: state.listOfMusic?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // context.read<AudioCubit>().addBannerMusic(state.listOfMusic![index],index);
                                    selIndex = index;
                                    context.read<AudioCubit>()
                                      ..onMode()
                                      ..getAudio(
                                          state.listOfMusic?[index].trackUrl ??
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
                                                                              .listOfMusic ??
                                                                          [],
                                                                      index:
                                                                          selIndex,
                                                                      context:
                                                                          context,
                                                                    ),
                                                                  )));
                                                    },
                                                    child: Container(
                                                        width: MediaQuery.sizeOf(
                                                                context)
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
                                                                        .listOfMusic?[
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
                                                                          .listOfMusic?[
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
                                                                        stream: context
                                                                            .read<
                                                                                AudioCubit>()
                                                                            .player
                                                                            .positionStream,

                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                              if(snapshot.data==context.read<AudioCubit>().player.duration){
                                                                                context.read<AudioCubit>()
                                                                                  ..pause()
                                                                                  ..nextMusic(
                                                                                      state.listOfMusic![++selIndex])..getAudio(state.listOfMusic
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
                                                                                  total: context.read<AudioCubit>().player.duration ?? const Duration(seconds: 0),
                                                                                  onSeek: (duration) {
                                                                                    context.read<AudioCubit>().seek(duration);
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
                                                                              context.read<AudioCubit>()
                                                                                ..pause()
                                                                                ..pervous(
                                                                                  state.listOfMusic![--selIndex],
                                                                                )
                                                                                ..getAudio(state.listOfMusic?[selIndex].trackUrl ?? "");
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
                                                                            context
                                                                                .read<AudioCubit>()
                                                                                .play();
                                                                            state.isPlay
                                                                                ? context.read<AudioCubit>().playy()
                                                                                : context.read<AudioCubit>().pause();
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
                                                                            if ((state.listOfMusic?.length ?? 0) - 1 !=
                                                                                index) {
                                                                              context.read<AudioCubit>()
                                                                                ..pause()
                                                                                ..nextMusic(state.listOfMusic![++selIndex])
                                                                                ..getAudio(state.listOfMusic?[selIndex].trackUrl ?? "");
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
                                          width: MediaQuery.sizeOf(context).width,
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
                                                  image: state.listOfMusic?[index]
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
                                                                .listOfMusic?[
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
                                                        state.listOfMusic?[index]
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
                      90.verticalSpace
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
