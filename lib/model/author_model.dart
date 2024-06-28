class AuthorModel{
  String? name;
  num? rating;
  String? image;
  String? id;
  String? job;
  AuthorModel({this.name,this.rating,this.image,this.id,this.job});

  factory AuthorModel.fromJson({required Map<String,dynamic>? data,String? id}){
    return AuthorModel(
      name: data?["name"],
      rating: data?["rating"],
      image: data?["image"],
      job: data?["job"],
      id: id,
    );
  }
  toJson(){
    return{
      "name":name,
      "rating":rating,
      "image":image,
      "job":job
    };
  }
}