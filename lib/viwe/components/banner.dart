// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:xmusic/controller/app_controller/app_cubit.dart';
// import 'package:xmusic/controller/app_controller/app_state.dart';
// import 'package:xmusic/controller/aud/audio_state.dart';
// import 'package:xmusic/model/music_model.dart';
// import 'package:xmusic/viwe/components/custom_network_image.dart';
// import 'package:xmusic/viwe/components/style.dart';
//
// import '../../controller/aud/audio_cubit.dart';
// import '../pages/home/home_page.dart';
//
// class BannerWidget extends StatelessWidget {
//   final List<MusicModel> list;
//
//   const BannerWidget({super.key, required this.list});
//
//   @override
//   Widget build(BuildContext context) {
//     return list.isEmpty ? SizedBox.shrink() : SizedBox(
//       height: 200.h,
//       child: BlocBuilder<AppCubit, AppState>(
//         builder: (context, state) {
//           return PageView.builder(
//               itemCount: list.length,
//               pageSnapping: false,
//               scrollDirection: Axis.horizontal,
//               onPageChanged: (s) {
//                 context.read<AppCubit>().selIndex(s);
//               },
//               itemBuilder: (context, index) {
//                 return BlocBuilder<MusicCubit, MusicState>(
//                   builder: (context, state) {
//                     return GestureDetector(
//                       onTap: () {
//                         context.read<MusicCubit>()
//                           ..onMode()
//                           ..getAudio(
//                               url: state.listOfMusic?[state
//                                   .listOfBannerIndex?[index] ?? 0].track ??
//                                   "");
//                         selIndex = state.listOfBannerIndex?[index] ?? 0;
//                       },
//                       child: BlocBuilder<AppCubit, AppState>(
//                         builder: (context, state) {
//                           return Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: state.selectIndex != index ? 30.h : 15
//                                     .h,
//                                 horizontal: 20.w),
//                             width: 200.w,
//                             height: state.selectIndex != index ? 150.h : 100.h,
//                             decoration: BoxDecoration(
//                                 color: Style.blackColor17,
//                                 borderRadius: BorderRadius.circular(16.r)
//                             ),
//                             child: CustomImageNetwork(
//                               image: list[index].image,
//                               radius: 16,
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 );
//               });
//         },
//       ),
//     );
//   }
// }