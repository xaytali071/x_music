

class BookModel {
  final String author;
  final String bookName;
  final String? yozuv;
  final String? image;
  final bool? like;
  final String? category;
  final String? pdf;
  final List<String>? audio;
  final String? bookId;


  BookModel({
    this.pdf = "",
    required this.yozuv,
    required this.author,
    required this.bookName,
    required this.image,
    required this.like,
    this.audio,
    required this.category,
    this.bookId,
  });

  factory BookModel.fromJson({Map? data,required String bookId}) {
    List<String>? list = [];
    data?["audio"]?.forEach((e){
      list.add(e);
    });
    return BookModel(
        pdf: data?["pdf"],
        author: data?["author"],
        bookName: data?["bookName"],
        image: data?["image"],
        like: data?["like"],
        category: data?["category"],
        audio: list,
        yozuv: data?["yozuv"],
        bookId: bookId,

    );
  }

  toJson() {
    return {
      "pdf": pdf,
      "author": author,
      "bookName": bookName,
      "like": like,
      "image": image,
      "yozuv": yozuv,
      "audio":audio,
      "category": category,
      "bookId": bookId,
    };
  }
}


