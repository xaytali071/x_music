import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../localStore/local_store.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioState());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker image = ImagePicker();
  final player = AudioPlayer();
  Duration? duration;
  String imageUrll = "";

  List<MusicModel> list11 = [];

  getMusicsList({required int index, required List<MusicModel>? list}) async {
    final playlist = ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: [
        for (int i = 0; i < (list?.length ?? 0); i++)
          AudioSource.uri(Uri.parse(list?[i].trackUrl ?? '')),
      ],
    );
    print(list?[index].trackName ?? '');
    await player.setAudioSource(playlist, initialIndex: index);
  }

  getAudio(String url) {
    player.setUrl(url);
  }

  getLocaleMusic(VoidCallback onSuccess) async {
    FilePickerResult? audioPath = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', "oog", "ma4", "waw"],
    );
    emit(state.copyWith(localAudioPath: audioPath?.files.single.path ?? ""));
    // localPath=audioPath?.files.single.path ?? "";
    onSuccess.call();
  }

  next() {
    player.seekToNext();
  }

  prevoius() {
    player.seekToPrevious();
  }

  play() {
    emit(state.copyWith(isPlay: state.isPlay = !state.isPlay));
  }

  pause() {
    player.pause();
  }

  playy() {
    player.play();
  }

  seek(Duration duration) {
    player.seek(duration);
    // emit(state.copyWith(seek: duration));
  }

  sielend() {
    emit(state.copyWith(isSilent: state.isSilent = !state.isSilent));
    state.isSilent ? player.setVolume(0) : player.setVolume(1);
  }

  setSpeed({required double speed}) {
    player.setSpeed(speed);
    emit(state.copyWith(speed: speed));
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
    var res = await firestore.collection("music1").get();
    list11.clear();
    for (var element in res.docs) {
      list11.add(MusicModel.fromJson(
        data: element.data(),
        authorData: await getArtistWithid(element.data()["artistId"]),
        id: element.id
      ));
    }
    emit(state.copyWith(listOfMusic: list11));
    emit(state.copyWith(isLoading: false));
  }

  fechMusic({required int page}) async {
   // emit(state.copyWith(isLoading: true));
    var res = await firestore.collection("music$page").get();

  //  list.clear();
    for (var element in res.docs) {
      list11.add(MusicModel.fromJson(
          data: element.data(),
          authorData: await getArtistWithid(element.data()["artistId"]),
          id: element.id
      ));
    }
    emit(state.copyWith(listOfMusic: list11));
    emit(state.copyWith(isLoading: false));
  }

  onMode() {
    emit(state.copyWith(darkMode: LocaleStore.getMode()));
  }

  getImageGallery(VoidCallback onSuccess) async {
    await image
        .pickImage(source: ImageSource.gallery, imageQuality: 65)
        .then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        emit(state.copyWith(imagePath: cropperImage?.path));
        onSuccess();
      }
    });
  }

  addNewAuthor({required String name, required String imagePath}) {
    emit(state.copyWith(isLoading: true));
    createImageUrl(
        imagePath: imagePath,
        onSuccess: () {
          firestore.collection("artist").add(
              AuthorModel(name: name, rating: 0, image: imageUrll).toJson());
        });
    emit(state.copyWith(isLoading: false));
  }

  createImageUrl({required String imagePath, VoidCallback? onSuccess}) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("artistImage/${DateTime.now().toString()}");
    await storageRef.putFile(File(imagePath ?? ""));

    String imageUrl = await storageRef.getDownloadURL();
    imageUrll = imageUrl;
    emit(state.copyWith(imageUrl: imageUrl));
    onSuccess?.call();
  }

  getAuthor() async {
    emit(state.copyWith(isLoading: true));
    List<AuthorModel> list = [];
    var res = await firestore.collection("artist").get();
    list.clear();
    for (var element in res.docs) {
      list.add(AuthorModel.fromJson(data: element.data(), id: element.id));
    }
    emit(state.copyWith(isLoading: false, listOfAuthor: list));
  }

  addNewAudio(
      {required String trackUrl,
      required String trackName,
      required String artistId,
        required String page,
        required String artistName,
      required VoidCallback? onSuccess}) async {
    emit(state.copyWith(isLoading: true));
    firestore.collection("music$page").add(MusicModel(
            trackUrl: trackUrl,
            trackName: trackName,
            artistId: artistId,
            ganre: "",
            rating: 0)
        .toJson());
    onSuccess?.call();
    emit(state.copyWith(isLoading: false));
  }

  getArtist() async {
    List<AuthorModel> list=[];
    emit(state.copyWith(isLoading: true));
    var res=await firestore.collection("artist").get();
    for(var e in res.docs){
      list.add(AuthorModel.fromJson(data: e.data(),id: e.id));
    }
    emit(state.copyWith(listOfAuthor: list,isLoading: false));
  }



  Future<String?> getAudioUrl(String videoUrl) async {
    emit(state.copyWith(isLoading: true));
    var youtube = YoutubeExplode();
    try {
      var video = await youtube.videos.get(videoUrl);
      var manifest = await youtube.videos.streamsClient.getManifest(video.id);
      var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
      emit(state.copyWith(audio: audioStreamInfo.url.toString()));
      emit(state.copyWith(isLoading: true));
      return audioStreamInfo.url.toString();
    } catch (e) {
      print("Error: $e");
      emit(state.copyWith(isLoading: false));
      return null;
    } finally {
      emit(state.copyWith(isLoading: false));
      youtube.close();
    }
  }

  getArtistWithid(String id) async {
    emit(state.copyWith(isLoading: true));
    var res = await firestore.collection("artist").doc(id).get();
    AuthorModel artist = AuthorModel.fromJson(data: res.data());
    return artist;
  }
}
