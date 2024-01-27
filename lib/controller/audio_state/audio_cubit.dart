import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xmusic/model/music_model.dart';

import '../localStore/local_store.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState>{
  AudioCubit() :super(AudioState());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final player=AudioPlayer();
  Duration? duration;
   String localPath="";


  getMusicsList({ required int index,required List<MusicModel>? list}) async {
    final playlist = ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: [
        for (int i = 0; i < (list?.length ?? 0); i++)
          AudioSource.uri(Uri.parse(list?[i].track ?? '')),
      ],
    );
    print(list?[index].trackName ?? '');
    await player.setAudioSource(playlist, initialIndex: index);

  }

  getAudio(String url){
    player.setUrl(url);
  }

  getLocaleMusic(VoidCallback onSuccess) async {
    FilePickerResult? audioPath=await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3',"oog","ma4","waw"],
    );
    emit(state.copyWith(localAudioPath: audioPath?.files.single.path ?? ""));
    localPath=audioPath?.files.single.path ?? "";
    onSuccess.call();
  }


  next(){
    player.seekToNext();
  }

  prevoius(){
    player.seekToPrevious();
  }

  play(){
    emit(state.copyWith(isPlay: state.isPlay=!state.isPlay));
  }

  pause(){
    player.pause();
  }

  playy(){
    player.play();
  }

  seek(Duration duration) {
    player.seek(duration);
   // emit(state.copyWith(seek: duration));
  }

  sielend(){
    emit(state.copyWith(isSilent:state.isSilent=!state.isSilent));
    state.isSilent ? player.setVolume(0) :player.setVolume(1);
  }
  setSpeed({required double speed}) {
    player.setSpeed(speed);
    emit(state.copyWith(speed:speed ));
    print(state.speed);
  }

  removeMusic() {
    player.dispose();
  }

  nextMusic(
    MusicModel music,
  ) {
    emit(state.copyWith(isPlay: true));
    emit(state.copyWith(music: music));
  }

  pervous(
    MusicModel music,
  ) {
    emit(state.copyWith(isPlay: true));
    emit(state.copyWith(music: music));
  }

  getMusic() async {
    emit(state.copyWith(isLoading: true));
    var res=await firestore.collection("music").get();
    List<MusicModel> list=[];
    list.clear();
    for (var element in res.docs) {
      list.add(MusicModel.fromJson(data: element.data()));
    }
    emit(state.copyWith(listOfMusic:list ));
    emit(state.copyWith(isLoading: false));
  }

  onMode() {
    emit(state.copyWith(darkMode: LocaleStore.getMode()));
  }

}