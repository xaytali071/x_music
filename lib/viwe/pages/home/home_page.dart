import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/viwe/add/HomePage2.dart';
import 'package:xmusic/viwe/components/image/avatar_image.dart';
import 'package:xmusic/viwe/components/background_widget.dart';

import 'package:xmusic/viwe/components/button/button_effect.dart';
import 'package:xmusic/viwe/components/custom_category.dart';
import 'package:xmusic/viwe/components/notification_widget.dart';
import 'package:xmusic/viwe/components/rating_bar.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/home/messages/message_page.dart';
import '../../../controller/audio_state/audio_state.dart';
import '../../components/image/custom_network_image.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

AudioPlayer playerAudio = AudioPlayer();
int selIndex = 0;

class _HomePageState extends ConsumerState<HomePage> {

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
    bool mode=ref.watch(appProvider).darkMode;
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
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon:  Icon(Icons.menu,color: mode ? Style.primaryColor : Style.darkPrimaryColor,)),
                    Text(
                      "XMusic",
                      style: Style.boldText(color: mode ? Style.primaryColor : Style.darkPrimaryColor ),
                    ),
                    const Spacer(),
                    GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (_) => const HomePage2()));
                        // },
                        child: NotificationWidget(count: watch1.messageCount,color: mode ? Style.primaryColor : Style.darkPrimaryColor ,onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>MessagesPage(listOfMessage: watch1.listOfMessage)));
                        },))
                  ],
                ),
              ),

              10.verticalSpace,
              const Category(list: ["Pop","Rok","Rep","Jaz","Audio kitob","Podcast","Intervyu"]),
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
                          // onLongPress: (){
                          //   showDialog(context: context, builder: (_){
                          //     return Dialog(
                          //       child: (
                          //       ElevatedButton(onPressed: (){
                          //         event.deleteAudio(watch.listOfMusic[index].id ?? "");
                          //       },child: Text("Delete"),)
                          //       ),
                          //     );
                          //   });
                          // },
                            onTap: ()  {
                              selIndex = index;
                              event..selectMusic(index: index)..isSearchList(false);
                              Future.delayed(const Duration(milliseconds: 700)).then((s){
                                event
                                  ..getAudio(watch.listOfMusic[index].trackUrl ?? "")
                                  ..playy();

                              });
                              print(selIndex);
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
                                        image:  watch.listOfMusic[index].artistImage ??
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
                                              watch.listOfMusic[index].trackName ??
                                                  "",
                                              style: Style.normalText(
                                                  color:mode
                                                      ? Style.whiteColor50
                                                      : Style.blackColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 170.w,
                                                child: Text(
                                                  watch.listOfMusic[index]
                                                          .artistName ??
                                                      "",
                                                  style: Style.miniText(
                                                      color: mode
                                                          ? Style.whiteColor50
                                                          : Style.blackColor),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                )),
                                            CustomRatingBar(rating: watch.listOfMusic[index].rating?.toDouble() ?? 0 / (watch.listOfMusic[index].userIdList?.length ?? 0))

                                          ],
                                        )
                                      ],
                                    ),
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
