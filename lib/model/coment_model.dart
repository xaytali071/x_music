import 'package:xmusic/model/user_model.dart';

class ComentModel {
  final String title;
  final String userId;
  final UserModel? user;
  final String comentId;

  ComentModel({
    required this.title,
    this.user,
    required this.userId,
    required this.comentId,
  });

  factory ComentModel.fromJson({
    required String title,
    UserModel? user,
    required String userId,
    required String comentId,
  }) {
    return ComentModel(
        title: title, user: user, userId: userId, comentId: comentId);
  }

  toJson() {
    return {
      "title": title,
      "userId": userId,
    };
  }
}
