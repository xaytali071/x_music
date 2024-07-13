import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';
import 'package:xmusic/viwe/components/style.dart';

import '../../controller/providers.dart';

class CustomListView extends ConsumerStatefulWidget {
  final List<MusicModel>? list;

  const CustomListView({super.key, required this.list});

  @override
  ConsumerState<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends ConsumerState<CustomListView> {
  @override
  Widget build(BuildContext context) {
    AppState watch=ref.watch(appProvider);
    final event=ref.read(appProvider.notifier);
    return ListView.builder(
        itemCount: widget.list?.length ?? 0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => MultiBlocProvider(
              //               providers: [
              //                 BlocProvider(
              //                   create: (context) => MusicCubit(),
              //                 ),
              //                 BlocProvider(
              //                   create: (context) => AppCubit(),
              //                 ),
              //               ],
              //               child: InMusicPage2(
              //                 music: widget.list, index: index,
              //               ),
              //             )));
            },
            child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  width: MediaQuery.sizeOf(context).width,
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xFFDAD4EC).withOpacity(0.2),
                  ),
                  child: Row(
                    children: [
                      CustomImageNetwork(
                          image: widget.list?[index].artistData?.image ?? "", width: 80, height: 80),
                      10.horizontalSpace,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 250.w,
                              child: Text(
                                widget.list?[index].artistData?.name ?? "",
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
                                widget.list?[index].trackName ?? "",
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
                )
          );
        });
  }
}
