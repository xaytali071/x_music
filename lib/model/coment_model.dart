import 'package:xmusic/model/user_model.dart';

class FeedbackModel {
  final String title;
  final String userId;
  final UserModel? user;
  final String? comentId;

  FeedbackModel({
    required this.title,
    this.user,
    required this.userId,
     this.comentId,
  });

  factory FeedbackModel.fromJson({required Map<String,dynamic>? data,required String comentId}) {
    return FeedbackModel(
        title:data? ["title"], user: data?["user"], userId: data?["userId"], comentId: comentId);
  }

  toJson() {
    return {
      "title": title,
      "userId": userId,
    };
  }
}
