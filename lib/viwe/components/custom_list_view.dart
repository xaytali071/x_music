import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';
import 'package:xmusic/viwe/components/style.dart';

class CustomListView extends StatefulWidget {
  final List<MusicModel>? list;

  const CustomListView({super.key, required this.list});

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  @override
  Widget build(BuildContext context) {
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
            child: BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return Container(
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
                          image: widget.list?[index].image, width: 80, height: 80),
                      10.horizontalSpace,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 250.w,
                              child: Text(
                                widget.list?[index].artist ?? "",
                                style: Style.normalText(
                                    color: state.darkMode
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
                                    color: state.darkMode
                                        ? Style.whiteColor50
                                        : Style.blackColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
