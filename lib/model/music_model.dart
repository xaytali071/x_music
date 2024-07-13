import 'package:xmusic/model/author_model.dart';

class MusicModel{
   String? trackUrl;
   String? trackName;
   AuthorModel? artistData;
  num? rating;
  String? artistId;
  String? ganre;
  int? year;
  String? other;
  String? id;
  MusicModel({this.trackUrl, this.trackName, this.artistData,this.rating,this.ganre,this.artistId,this.year,this.other,this.id});


  factory MusicModel.fromJson({ required Map<String,dynamic>? data,required AuthorModel? authorData,required String id,required String audUrl}){
    return MusicModel(
      trackUrl: audUrl,
      trackName: data?["trackName"],
      artistData: authorData,
      rating: data?["rating"],
      ganre: data?["ganre"],
      artistId: data?["artistId"],
      year: data?["year"],
      other: data?["other"],
      id: id

    );
  }

  toJson(){
    return {
      "track":trackUrl,
      "trackName":trackName,
      "rating":rating,
      "ganre":ganre,
      "artistId":artistId,
      "year":year,
      "other":other,
    };
  }
}