

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/author_model.dart';
import '../../model/music_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_state.freezed.dart';
@freezed
class AudioState with _$AudioState {

  const factory AudioState({
    @Default(true) bool isPlay,
    @Default(false) bool isPause,
    @Default(false)  bool isSilent,
    @Default(1) double? speed,
    @Default(false) bool isLoading,
    int? selectIndex,
    @Default([]) List<MusicModel> listOfMusic,
    @Default([]) List<String> listOfDoc,
    @Default("") String localAudioPath,
    @Default(false) bool darkMode,
    @Default("") String imagePath,
     MusicModel? music,
    @Default([]) List<AuthorModel> listOfAuthor,
    @Default("")  audio,
    @Default("")  imageUrl,
    @Default([]) List<MusicModel> listOfMusicArtist,
   // @Default([]) List<DocumentSnapshot<MusicModel>> listOfMusic,
    @Default(true) bool hasMoreData,
    DocumentSnapshot? lastDocument,
    //@Default([]) List<MusicModel> newMusics
})=
_AudioState;
}
  