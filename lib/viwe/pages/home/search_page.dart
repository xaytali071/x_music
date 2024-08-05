import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';
import 'package:xmusic/viwe/components/form_field/keyboard_dissimer.dart';
import 'package:xmusic/viwe/pages/home/music_by_artist.dart';

import '../../components/button/button_effect.dart';
import '../../components/image/custom_network_image.dart';
import '../../components/style.dart';
import 'home_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {

  TextEditingController name=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final event=ref.read(audioProvider.notifier);
    AudioState watch=ref.watch(audioProvider);
    bool mode=ref.watch(appProvider).darkMode;
    return KeyboardDissimer(
      child: BackGroundWidget(
        child:  SingleChildScrollView(
          child: Column(
            children: [
              50.verticalSpace,
               Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 15.w),
                 child: CustomTextFormField(hint: "Search",borderColor: Style.blackColor17,controller: name,onChanged: (s){
                   event.searchMusic(name: s.substring(0,1).toUpperCase()+s.substring(1));
                   event.searchAuthor(name: s.substring(0,1).toUpperCase()+s.substring(1));
                 },),
               ),

              20.verticalSpace,
              ListView.builder(
                shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: watch.listOfSearchRes.length,
                  itemBuilder: (context,index){
                return InkWell(
                    onTap: ()  {
                      selIndex = index;
                      event..selectMusic(index: index)..isSearchList(true);
                      Future.delayed(const Duration(milliseconds: 700)).then((s){
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
              ListView.builder(
                shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: watch.listOfSearchAuthor.length,
                  itemBuilder: (context,index){
                    return InkWell(
                        onTap: ()  {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>MusicByArtist(name: watch.listOfSearchAuthor[index].name ?? "")));

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
                                ClipOval(
                                  child: CustomImageNetwork(
                                      image:  watch.listOfSearchAuthor[index].image ??
                                          "",
                                      width: 80,
                                      height: 80),
                                ),
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
                                          watch.listOfSearchAuthor[index].name ??
                                              "",
                                          style: Style.normalText(
                                              color: mode
                                                  ? Style.whiteColor50
                                                  : Style.blackColor),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  }),
              100.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
