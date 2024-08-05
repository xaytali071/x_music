import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/pages/home/home_page.dart';
import '../../model/rating_model.dart';
import '../local_store.dart';
import 'audio_state.dart';

class AudioNotifire extends StateNotifier<AudioState> {
  AudioNotifire() : super(AudioState());
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
    // player.setUrl(url);
    player.setAudioSource(AudioSource.uri(Uri.parse(url)));
  }

  selectMusic({
    required int index,
  }) {
    state = state.copyWith(selectIndex: index);
  }


  next() {
    player.seekToNext();
  }

  prevoius() {
    player.seekToPrevious();
  }


  complaeteMusic({required List<MusicModel> music,required int index,}){
    player.playerStateStream.listen((s){
      if(s.processingState==ProcessingState.completed){
             nextMusic(music[index]);
             getAudio(music[index].trackUrl ?? "");
             playy();
             print(selIndex);

      }
    });
  }



  stop() {
    player.stop();
  }

  play() {
    bool play = state.isPlay;
    play = play = !play;
    state = state.copyWith(isPlay: play);
  }

  pause() {
    player.pause();
  }

  playy() {
    player.play();
  }

  seek(Duration duration) {
    player.seek(duration);
    // state=(state.copyWith(seek: duration));
  }

  sielend() {
    state = (state.copyWith(isSilent: state.isSilent != state.isSilent));
    state.isSilent ? player.setVolume(0) : player.setVolume(1);
  }

  setSpeed({required double speed}) {
    player.setSpeed(speed);
    state = (state.copyWith(speed: speed));
    print(state.speed);
  }

  removeMusic() {
    player.dispose();
  }

  nextMusic(
    MusicModel music,
  ) {
    state = (state.copyWith(isPlay: true));
    state = (state.copyWith(music: music));
  }

  pervous(
    MusicModel music,
  ) {
    state = (state.copyWith(isPlay: true));
    state = (state.copyWith(music: music));
  }

  getMusic() async {
    state = (state.copyWith(isLoading: true));
    QuerySnapshot last;
    var res = await firestore.collection("music").limit(7).get();

    list11.clear();
    for (var element in res.docs) {
      list11.add(MusicModel.fromJson(
        data: element.data(),
        id: element.id,
      ));
      state = state.copyWith(lastDocument: res.docs.last);
    }
    state = (state.copyWith(
      listOfMusic: list11,
    ));
    state = (state.copyWith(isLoading: false));
  }



  getImageGallery(VoidCallback onSuccess) async {
    await image
        .pickImage(source: ImageSource.gallery, imageQuality: 65)
        .then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        state = (state.copyWith(imagePath: cropperImage?.path ?? ""));
        onSuccess();
      }
    });
  }

  addNewAuthor({required String name, required String imagePath}) {
    state = (state.copyWith(isLoading: true));
    createImageUrl(
        imagePath: imagePath,
        onSuccess: () {
          firestore.collection("artist").add(
              AuthorModel(name: name, rating: 0, image: imageUrll).toJson());
        });
    state = (state.copyWith(isLoading: false));
  }

  createImageUrl({required String imagePath, VoidCallback? onSuccess}) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("artistImage/${DateTime.now().toString()}");
    await storageRef.putFile(File(imagePath ?? ""));

    String imageUrl = await storageRef.getDownloadURL();
    imageUrll = imageUrl;
    state = (state.copyWith(imageUrl: imageUrl));
    onSuccess?.call();
  }

  getAuthor() async {
    state = (state.copyWith(isLoading: true));
    List<AuthorModel> list = [];
    var res = await firestore.collection("artist").get();
    list.clear();
    for (var element in res.docs) {
      list.add(AuthorModel.fromJson(data: element.data(), id: element.id));
    }
    state = (state.copyWith(isLoading: false, listOfAuthor: list));
  }

  addNewAudio(
      {required String trackUrl,
      required String trackName,
      required String artistImage,
      required String artistName,
        required String ganre,
        required String collection,
      required VoidCallback? onSuccess}) async {
    state = (state.copyWith(isLoading: true));
    firestore.collection(collection).add(MusicModel(
            trackUrl: trackUrl,
            trackName: trackName,
            artistName: artistName,
            artistImage: artistImage,
            ganre: ganre,
            rating: 0)
        .toJson());
    onSuccess?.call();
    state = (state.copyWith(isLoading: false));
  }

  getFile({
  required VoidCallback? onSuccess
  }
) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && (result.files.single.path?.isNotEmpty ?? false)) {
      PlatformFile file = result.files.first;
      String filePath = result.files.single.path!;
      state=state.copyWith(filePath: filePath);
    }
  }

  addNewAudioFile(
      {required String filePath,
        required String trackName,
        required String artistImage,
        required String artistName,
        required String ganre,
        required String collection,
        required VoidCallback? onSuccess}) async {
    state = (state.copyWith(isLoading: true));
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("$collection/${DateTime.now().toString()}");
    await storageRef.putFile(File(filePath));
    var res = await storageRef.getDownloadURL();
    onSuccess?.call();
    firestore.collection(collection).add(MusicModel(
        trackUrl: res,
        trackName: trackName,
        artistName: artistName,
        artistImage: artistImage,
        ganre: ganre,
        rating: 0)
        .toJson());
    onSuccess?.call();
    state = (state.copyWith(isLoading: false));
  }

  getArtist() async {
    List<AuthorModel> list = [];
    state = (state.copyWith(isLoading: true));
    var res = await firestore.collection("artist").get();
    for (var e in res.docs) {
      list.add(AuthorModel.fromJson(data: e.data(), id: e.id));
    }
    state = (state.copyWith(listOfAuthor: list, isLoading: false));
  }

  deleteAudio(String docId){
    firestore.collection("music").doc(docId).delete();
  }

  getArtistWithid(String id) async {
    state = (state.copyWith(isLoading: true));
    var res = await firestore.collection("artist").doc(id).get();
    AuthorModel artist = AuthorModel.fromJson(data: res.data());
    return artist;
  }

  Future<void> fetchMusic() async {
    if (state.isLoading || !state.hasMoreData) return;

    //  state = state.copyWith(isLoading: true);

    Query query = FirebaseFirestore.instance
        .collection('music')
        .orderBy('trackName',)
        .limit(7);

    if (state.lastDocument != null) {
      query = query.startAfterDocument(state.lastDocument!);
    }

    final QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      state = state.copyWith(hasMoreData: false);
    } else {
      List<MusicModel> newMusics = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MusicModel.fromJson(
          data: data,
          id: doc.id,
        );
      }).toList();
      state = state.copyWith(
        listOfMusic: [...state.listOfMusic, ...newMusics],
        lastDocument: snapshot.docs.last,
      );
    }

    state = state.copyWith(isLoading: false);
  }

  clearMusic(){
  state=state.copyWith(listOfMusic: [],lastDocument: null,);
  }

  sendRating({
    required num rating,
    required String docId,
    required List<String> list
  }){
    state=(state.copyWith(isLoading: true));
    firestore.collection("music").doc(docId).update({"rating":rating,"userId":list});
    state=(state.copyWith(isLoading: false));
  }

  searchMusic({required String name}) async {
    List<MusicModel> list = [];
    if (name.isEmpty) {
      state = (state.copyWith(listOfSearchRes: []));
    } else {
      var res = await firestore
          .collection("music")
          .orderBy("trackName")
          .startAt([name]).endAt(["$name\uf8ff"]).get();

      for (var element in res.docs) {
        list.add(MusicModel.fromJson(data: element.data(), id: element.id));
      }
      print(list);
      state = (state.copyWith(listOfSearchRes: list));
    }
  }

  searchMusicbyAuthor({required String name})async{
    List<MusicModel> list=[];
    state=state.copyWith(isLoading: true);
    var res=await firestore.collection("music").where("artistName",isEqualTo: name).get();
    for(var e in res.docs){
      list.add(MusicModel.fromJson(data: e.data(), id: e.id));
    }
    state=state.copyWith(listOfSearchRes: list,isLoading: false);
  }


  searchMusicbyGanre({required String name})async{
    List<MusicModel> list=[];
    state=state.copyWith(isLoading: true);
    var res=await firestore.collection("music").where("ganre",isEqualTo: name).get();
    for(var e in res.docs){
      list.add(MusicModel.fromJson(data: e.data(), id: e.id));
    }
    state=state.copyWith(listOfSearchRes: list,isLoading: false);
  }

  searchAuthor({required String name}) async {
    List<AuthorModel> list = [];
    if (name.isEmpty) {
      state = (state.copyWith(listOfSearchAuthor: []));
    } else {
      var res = await firestore
          .collection("artist")
          .orderBy("name")
          .startAt([name]).endAt(["$name\uf8ff"]).get();

      for (var element in res.docs) {
        list.add(AuthorModel.fromJson(data: element.data(), id: element.id));
      }
      print(list);
      state = (state.copyWith(listOfSearchAuthor: list));
    }
  }

  isSearchList(bool value){
    state=state.copyWith(isSearchList: value);
  }
}
