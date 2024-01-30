class UserModel {
  final String? name;
  final String? password;
  final String? avatar;
  final String? email;

  UserModel(
      {required this.name,
        required this.password,
        this.avatar,
        required this.email,
      });

  factory UserModel.fromJson({Map? data,}) {
    return UserModel(
        name: data?["name"],
        password: data?["password"],
        avatar: data?["avatar"],
        email: data?["email"],
    );
  }

  toJson() {
    return {
      "name": name,
      "password": password,
      "avatar": avatar,
      "email": email,
    };
  }
}