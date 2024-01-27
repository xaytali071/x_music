// import 'dart:ui';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xmusic/controller/aud/audio_state.dart';
// import 'package:xmusic/controller/localStore/local_store.dart';
//
// import '../../model/music_model.dart';
//
// class MusicCubit extends Cubit<MusicState> {
//   MusicCubit() : super(MusicState());
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   final player = AudioPlayer();
//   Stream<Duration>? position;
//   Duration? duration = const Duration();
//   String localePath = "";
//
//   getAudio({required String url}) async {
//     emit(state.copyWith(isPlay: true));
//     await player.play(UrlSource(url)).then((value) {
//       maxDuration();
//     });
//     emit(state.copyWith(isPlay: true));
//   }
//
//   play() {
//     emit(state.copyWith(isPlay: state.isPlay = !state.isPlay));
//   }
//
//   onStream(Duration duration) {
//     emit(state.copyWith(stream: duration));
//   }
//
//   stopMusic() {
//     emit(state.copyWith(isPlay: true));
//     player.stop();
//   }
//
//   addBannerMusic(MusicModel music,int index) {
//     List<MusicModel> list = [];
//     List<int> l=[];
//     l=state.listOfBannerIndex ?? [];
// list=state.listOfBanner ?? [];
//     if (list.length == 5) {
//       list.removeAt(4);
//       l.removeAt(4);
//       list.add(music);
//       l.add(index);
//     } else {
//       list.add(music);
//       l.add(index);
//     }
//     emit(state.copyWith(listOfBanner: list,listOfBannerIndex: l));
//   }
//
//   getBannerMusic(List? listOfIndex, List<MusicModel>? listMusic) {
//     List list = [];
//     for (int i = 0; i < (listOfIndex?.length ?? 0); i++) {}
//     emit(state.copyWith(listOfBanner: []));
//   }
//
//   seek(Duration duration) {
//     player.seek(duration);
//     emit(state.copyWith(seek: duration));
//   }
//
//   ramoveMusic() {
//     player.dispose();
//   }
//
//   maxDuration() {
//     player.getDuration().then((value) {
//       emit(state.copyWith(maxDuration: value));
//     });
//     emit(state.copyWith(isPlay: true));
//   }
//
//   pause() {
//     player.pause();
//     emit(state.copyWith(isPlay: false));
//   }
//
//   resume() {
//     player.resume();
//     emit(state.copyWith(isPlay: true));
//   }
//
//   sped(){
//     player.setBalance(0.5);
//   }
//
//   onMode() {
//     emit(state.copyWith(darkMode: LocaleStore.getMode()));
//   }
//
//   getIndex(int index) {
//     emit(state.copyWith(selectIndex: index));
//   }
//
//   nextMusic(
//     MusicModel music,
//   ) {
//     emit(state.copyWith(isPlay: true));
//     emit(state.copyWith(music: music));
//   }
//
//   pervous(
//     MusicModel music,
//   ) {
//     emit(state.copyWith(isPlay: true));
//     emit(state.copyWith(music: music));
//   }
//
//   getLocaleMusic(VoidCallback onSuccess) async {
//     FilePickerResult? audioPath = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mp3', "oog", "ma4", "waw"],
//     );
//     emit(state.copyWith(localeAudioPath: audioPath?.files.single.path ?? ""));
//     localePath = audioPath?.files.single.path ?? "";
//     onSuccess.call();
//   }
//
//   getMusic() async {
//     emit(state.copyWith(isLoading: true));
//     var res = await firestore.collection("music").get();
//     List<MusicModel> list = [];
//     list.clear();
//     for (var element in res.docs) {
//       list.add(MusicModel.fromJson(data: element.data()));
//     }
//     emit(state.copyWith(listOfMusic: list));
//     emit(state.copyWith(isLoading: false));
//   }
// }
