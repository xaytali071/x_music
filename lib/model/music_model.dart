
import 'package:xmusic/model/author_model.dart';

class MusicModel{
   String? trackUrl;
   String? trackName;
   String? artistImage;
   String? artistName;
  num? rating;
  String? ganre;
  int? year;
  String? other;
  String? id;
  List<String>? userIdList;
  MusicModel({this.trackUrl, this.trackName, this.rating,this.ganre,this.artistImage,this.artistName,this.year,this.other,this.id,this.userIdList});


  factory MusicModel.fromJson({ required Map<String,dynamic>? data,required String id,}){

    List<String>? list = [];
    data?["userId"]?.forEach((e){
      list.add(e);
    });

    return MusicModel(
      trackUrl: data?["track"],
      trackName: data?["trackName"],
      rating: data?["rating"],
      ganre: data?["ganre"],
      artistImage: data?["artistImage"],
      artistName: data?["artistName"],
      year: data?["year"],
      other: data?["other"],
      id: id,
      userIdList: list,
    );
  }

  toJson(){
    return {
      "track":trackUrl,
      "trackName":trackName,
      "rating":rating,
      "ganre":ganre,
      "artistName":artistName,
      "artistImage":artistImage,
      "year":year,
      "other":other,
    };
  }
}