import 'package:xmusic/model/music_model.dart';


class AudioState {
   bool isPlay;
   bool isPause;
   bool isSilent;
   double? speed;
  bool isLoading;
  late final int selectIndex;
  final List<MusicModel>? listOfMusic;
  final List<String>? listOfDoc;
  final String? localAudioPath;
  bool darkMode;
  final MusicModel? music;
  AudioState(
      {this.selectIndex = 0,
      this.isPlay = true,
      this.isPause = true,
      this.isSilent = true,
      this.speed=1.0,
      this.isLoading = false,
      this.listOfMusic,
      this.listOfDoc,
        this.localAudioPath,
        this.darkMode=false,
        this.music
      });

  AudioState copyWith({
    bool? isPlay,
    bool? isPause,
    bool? isSilent,
    double? speed,
    bool? isLoading,
    List<MusicModel>? listOfMusic ,
    int? selectIndex,
    List<String>? listOfDoc,
    String? localAudioPath,
    bool? darkMode,
    MusicModel? music
  }) {
    return AudioState(
      isPlay: isPlay ?? this.isPlay,
      isPause: isPause ?? this.isPause,
      isSilent: isSilent ?? this.isSilent,
      speed: speed ?? this.speed,
      isLoading: isLoading ?? this.isLoading,
      listOfMusic: listOfMusic ?? this.listOfMusic,
      selectIndex: selectIndex ?? this.selectIndex,
      listOfDoc: listOfDoc ?? this.listOfDoc,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      darkMode: darkMode ?? this.darkMode,
      music: music ?? this.music,
    );
  }
}
