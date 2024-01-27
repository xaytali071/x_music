//
//
// import '../../model/music_model.dart';
//
// class MusicState {
//    bool isPlay;
//   final bool isPause;
//   final bool isSilent;
//   final double speed;
//   bool isLoading;
//   late final int selectIndex;
//   final List<MusicModel>? listOfMusic;
//   final List<String>? listOfDoc;
//   final Duration maxDuration;
//   Duration seek;
//   Duration? stream;
//   bool darkMode;
//  final MusicModel? music;
//  final String? localeAudioPath;
//  final List<MusicModel>? listOfBanner;
//  final List<int>? listOfBannerIndex;
//   MusicState(
//       {this.selectIndex = 0,
//         this.isPlay = true,
//         this.isPause = true,
//         this.isSilent = true,
//         this.speed = 1,
//         this.isLoading = false,
//         this.maxDuration=const Duration(milliseconds: 0),
//         this.seek=const Duration(milliseconds: 0),
//         this.stream,
//         this.darkMode=false,
//         this.listOfMusic,
//         this.listOfDoc,
//         this.music,
//         this.localeAudioPath,
//         this.listOfBanner,
//         this.listOfBannerIndex,
//       });
//
//   MusicState copyWith({
//     bool? isPlay,
//     bool? isPause,
//     bool? isSilent,
//     double? speed,
//     bool? isLoading,
//     int? selectIndex,
//     Duration? maxDuration,
//     Duration? seek,
//     Duration? stream,
//     bool? darkMode,
//      MusicModel? music,
//     List<MusicModel>? listOfMusic,
//     List<String>? listOfDoc,
//     String? localeAudioPath,
//     List<MusicModel>? listOfBanner,
//     List<int>? listOfBannerIndex,
//   }) {
//     return MusicState(
//       isPlay: isPlay ?? this.isPlay,
//       isPause: isPause ?? this.isPause,
//       isSilent: isSilent ?? this.isSilent,
//       speed: speed ?? this.speed,
//       isLoading: isLoading ?? this.isLoading,
//       selectIndex: selectIndex ?? this.selectIndex,
//       maxDuration: maxDuration ?? this.maxDuration,
//       seek: seek ?? this.seek,
//       stream: stream ?? this.stream,
//       darkMode: darkMode ?? this.darkMode,
//       listOfDoc: listOfDoc ?? this.listOfDoc,
//       listOfMusic: listOfMusic ?? this.listOfMusic,
//       music: music ?? this.music,
//       localeAudioPath: localeAudioPath ?? this.localeAudioPath,
//       listOfBanner: listOfBanner ?? this.listOfBanner,
//       listOfBannerIndex: listOfBannerIndex ?? this.listOfBannerIndex,
//     );
//   }
// }