class RatinByMovieModel {
  final String? movieName;
  final String? movieImage;
  final num? rating;
  final List<String>? userIdList;


  RatinByMovieModel({required this.movieName, required this.movieImage,required this.rating,required this.userIdList});

  factory RatinByMovieModel.fromJson(Map<String, dynamic>? data){
    List<String>? list = [];
    data?["userId"]?.forEach((e){
      list.add(e);
    });
    return RatinByMovieModel(
        movieImage: data?["movieImage"],
        movieName: data?["movieName"],
        rating:data?["rating"],
        userIdList: list
    );
  }

  toJson() {
    return {
      "movieImage": movieImage,
      "movieName": movieName,
      "rating":rating,
      "userId":userIdList,

    };
  }
}


class RatingByIdModel{
  final num? rating;
  final String? id;

  RatingByIdModel({required this.rating,required this.id});

  factory RatingByIdModel.fromJson(Map? data){
    return RatingByIdModel(rating:data?["rating"] , id: data?["userId"]);
  }

  toJson(){
    return {
      "rating":rating,
      "userId":id,
    };
  }
}