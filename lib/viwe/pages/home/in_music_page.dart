// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:xmusic/controller/app_controller/app_cubit.dart';
// import 'package:xmusic/controller/app_controller/app_state.dart';
// import 'package:xmusic/controller/aud/audio_cubit.dart';
// import 'package:xmusic/controller/audio_cubit/audio_cubit.dart';
// import 'package:xmusic/controller/audio_cubit/audio_state.dart';
// import 'package:xmusic/controller/localStore/local_store.dart';
// import 'package:xmusic/model/music_model.dart';
// import 'package:xmusic/viwe/components/custom_list_view.dart';
// import 'package:xmusic/viwe/components/custom_network_image.dart';
// import 'package:xmusic/viwe/components/style.dart';
//
// class InMusicPage extends StatefulWidget {
//   final List<MusicModel>? music;
//   final int index;
//
//   const InMusicPage({super.key, required this.music, required this.index});
//
//   @override
//   State<InMusicPage> createState() => _InMusicPageState();
// }
//
// class _InMusicPageState extends State<InMusicPage> {
//
//   music(){
//     if(widget.music?.isEmpty ?? false){
//       context.read<MusicCubit>().getMusics1(
//             index: widget.index,
//             list: widget.music ?? [],
//           );
//     }else{
//       context.read<AudioCubit>().player.setFilePath(AudioCubit().localPath);
//     }
//   }
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       context.read<AudioCubit>().getMusics1(
//         index: widget.index,
//         list: widget.music ?? [],
//       );
//       context.read<AppCubit>().getMode();
//      // context.read<AudioCubit>().play();
//     });
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//     context.read<AudioCubit>().removeMusic();
//     super.dispose();
//   }
//
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppCubit, AppState>(
//   builder: (context, state) {
//     return Scaffold(
//       backgroundColor: state.darkMode ? Style.blackColor : Style.whiteColor,
//       body: BlocBuilder<AudioCubit, AudioState>(
//         builder: (context, state) {
//           return Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 child: BlocBuilder<AppCubit, AppState>(
//   builder: (context, state) {
//     return Column(
//                   children: [
//                     100.verticalSpace,
//                     CustomImageNetwork(
//                       image: widget.music?[widget.index].image ?? "",
//                       width: 250,
//                       height: 250,
//                       radius: 16,
//                     ),
//                     10.verticalSpace,
//                     Center(
//                       child: Text(
//                         widget.music?[widget.index].artist ?? "",
//                         style: Style.normalText(color: state.darkMode ? Style.whiteColor : Style.blackColor),
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         widget.music?[widget.index].trackName ?? "",
//                         style: Style.miniText(color: state.darkMode ? Style.whiteColor50 : Style.blackColor),
//                       ),
//                     ),
//                     20.verticalSpace,
//                     StreamBuilder(
//                         stream:
//                             context.read<AudioCubit>().player.positionStream,
//                         builder: (context, s) {
//                           return Column(
//                             children: [
//                               BlocBuilder<AppCubit, AppState>(
//   builder: (context, state) {
//     return Slider(
//                                 min: 0,
//                                 max: context
//                                         .read<AudioCubit>()
//                                         .player
//                                         .duration
//                                         ?.inSeconds
//                                         .toDouble() ??
//                                     1,
//                                 value: (s.data?.inSeconds.toDouble() ?? 1),
//                                 onChanged: (value) {
//                                   context
//                                       .read<AudioCubit>()
//                                       .player
//                                       .seek(Duration(seconds: value.toInt()));
//                                   context.read<AudioCubit>().play();
//                                 },
//                                 inactiveColor: state.darkMode ? Style.whiteColor50 : Style.blackColor50,
//                                 activeColor: state.darkMode ? Style.whiteColor : Style.blackColor,
//                                 onChangeStart: (a) {
//                                   context.read<AudioCubit>().pause();
//                                 },
//                                 onChangeEnd: (b) {
//                                   context.read<AudioCubit>().play();
//                                 },
//                               );
//   },
// ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.center,
//                                 children: [
//                                   15.horizontalSpace,
//                                   Text(
//                                     s.data.toString().substring(0, 7),
//                                     style:  TextStyle(color: state.darkMode ? Style.whiteColor : Style.blackColor),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           );
//                         }),
//                     20.verticalSpace,
//                     BlocBuilder<AudioCubit, AudioState>(
//   builder: (context, state) {
//     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               context.read<AudioCubit>().prevoius();
//                               if (widget.index != 0) {
//                                 widget.index - 1;
//                                 setState(() {});
//                               }
//                             },
//                             icon: Icon(
//                               Icons.skip_previous,
//                               size: 40,
//                             )),
//                         IconButton(
//                             onPressed: () {
//                               context.read<AudioCubit>().play();
//                             },
//                             icon: state.isPlay
//                                 ? Icon(
//                                     Icons.pause,
//                                     size: 60,
//                                   )
//                                 : Icon(
//                                     Icons.play_circle,
//                                     size: 60,
//                                   )),
//                         IconButton(
//                             onPressed: () {
//                               context.read<AudioCubit>().next();
//                             },
//                             icon: Icon(
//                               Icons.skip_next,
//                               size: 40,
//                             )),
//                       ],
//                     );
//   },
// ),
//                   ],
//                 );
//   },
// ),
//               ),
//               Positioned(
//                 child: DraggableScrollableSheet(
//                   initialChildSize: 0.15,
//                   minChildSize: 0.15,
//                   maxChildSize: 0.8,
//                   builder: (context, controller) {
//                     return ListView(
//                       controller: controller,
//                       children: [
//                         Column(
//                           children: [
//                             BlocBuilder<AppCubit, AppState>(
//   builder: (context, state) {
//     return Container(
//                               width: MediaQuery.sizeOf(context).width,
//                               height: MediaQuery.sizeOf(context).height,
//                               decoration: BoxDecoration(
//                                   gradient: state.darkMode ? Style.darkGradient : Style.gradient,
//                                   borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(20.r),
//                                       topLeft: Radius.circular(20.r))),
//                               child: CustomListView(list: widget.music,),
//                             );
//   },
// ),
//                           ],
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   },
// );
//   }
// }
