class BannerModel{
 final String bookName;
 final String author;
 final String desc;
 final String image;

 BannerModel({this.bookName="", this.author="", this.desc="",this.image="",});

 factory BannerModel.fromJson({required Map? data,required id }){
  return BannerModel(
   bookName: data?["bookName"],
   author: data?["author"],
   desc: data?["desc"],
   image: data?["image"],
  );
 }

 toJson(){
  return {
   "bookName": bookName,
   "author":author,
   "desc":desc,
   "image":image,
  };
 }
}