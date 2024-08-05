class UserModel {
  final String? name;
  final String? password;
  final String? avatar;
  final String? email;
  final String? fcm;
  final String? model;

  UserModel(
      { this.name,
         this.password,
        this.avatar,
         this.email,
         this.fcm,
         this.model,
      });

  factory UserModel.fromJson({Map? data,}) {
    return UserModel(
        name: data?["name"],
        password: data?["password"],
        avatar: data?["avatar"],
        email: data?["email"],
      fcm: data?["fcm"],
      model: data?["model"],
    );
  }

  toJson() {
    return {
      "name": name,
      "password": password,
      "avatar": avatar,
      "email": email,
      "fcm":fcm,
      "model":model
    };
  }
}