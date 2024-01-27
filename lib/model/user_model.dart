class UserModel {
  final String? name;
  final String? username;
  final String? password;
  final String? avatar;
  final String? email;
  final String? phone;
  final String? docId;

  UserModel(
      {required this.name,
        required this.username,
        required this.password,
        this.avatar,
        required this.email,
        required this.phone,
        this.docId});

  factory UserModel.fromJson({Map? data,required String docId}) {
    return UserModel(
        name: data?["name"],
        username: data?["username"],
        password: data?["password"],
        avatar: data?["avatar"],
        email: data?["email"],
        phone: data?["phone"],
        docId: docId
    );
  }

  toJson() {
    return {
      "name": name,
      "username": username,
      "password": password,
      "avatar": avatar,
      "email": email,
      "phone": phone,
    };
  }
}