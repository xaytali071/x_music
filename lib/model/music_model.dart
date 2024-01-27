class MusicModel{
  final String? image;
  final String? track;
  final String? trackName;
  final String? artist;
  MusicModel({this.image, this.track, this.trackName, this.artist});


  factory MusicModel.fromJson({ required Map<String,dynamic>? data}){
    return MusicModel(
      image: data?["image"],
      track: data?["track"],
      trackName: data?["trackName"],
      artist: data?["artist"],
    );
  }

  toJson(){
    return {
      "image": image,
      "artist":artist,
      "track":track,
      "trackName":trackName,
    };
  }
}