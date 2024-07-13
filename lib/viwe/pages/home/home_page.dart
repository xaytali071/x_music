import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/add/HomePage2.dart';
import 'package:xmusic/viwe/components/avatar_image.dart';
import 'package:xmusic/viwe/components/background_widget.dart';

import 'package:xmusic/viwe/components/button_effect.dart';
import 'package:xmusic/viwe/components/custom_category.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/components/tab_widget.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../components/custom_network_image.dart';
import '../bottom_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

AudioPlayer playerAudio = AudioPlayer();
int selIndex = 0;

class _HomePageState extends ConsumerState<HomePage> {
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

  int page = 2;
  RefreshController refreshController = RefreshController();

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    UserState watch1 = ref.watch(userProvider);
    return BackGroundWidget(
        child: SafeArea(
      child: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          //   event.getMusic();
          refreshController.refreshCompleted();
        },
        onLoading: () {
          event.fetchMusic();
          refreshController.loadComplete();
        },
        child: SingleChildScrollView(
          child: Column(
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
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage2()));
                        },
                        child: AvatarImage(
                          image: watch1.userModel?.avatar ?? "",
                          size: 30,
                        ))
                  ],
                ),
              ),
              10.verticalSpace,
              const TabWidget(),
              10.verticalSpace,
              Category(list: watch.listOfAuthor),
              10.verticalSpace,
              // BannerWidget(list: state.listOfBanner ?? [],),
              10.verticalSpace,
              watch.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: watch.listOfMusic.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              selIndex = index;
                              setState(() {});
                              event
                                ..getAudio(await event.getAudioUrl(
                                        watch.listOfMusic[selIndex].trackUrl ??
                                            "") ??
                                    "")
                                ..playy()
                                ..selectMusic(index: index);
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
                                        image:  watch.listOfMusic[index]
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
                                              watch.listOfMusic[index]
                                                      .artistData?.name ??
                                                  "",
                                              style: Style.normalText(
                                                  color: watch.darkMode
                                                      ? Style.whiteColor50
                                                      : Style.blackColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )),
                                        SizedBox(
                                            width: 250.w,
                                            child: Text(
                                              watch.listOfMusic[index]
                                                      .trackName ??
                                                  "",
                                              style: Style.miniText(
                                                  color: watch.darkMode
                                                      ? Style.whiteColor50
                                                      : Style.blackColor),
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
              90.verticalSpace
            ],
          ),
        ),
      ),
    ));
  }
}
