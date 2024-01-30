import '../../model/user_model.dart';

class UserState {
  bool isGoogleLoading;
  bool isFacebookLoading;
  bool isLoading;
  UserModel? userModel;
  String verificationId;
  String phone;
  String? errorText;
  final String? imageUrl;
  final String? imagePath;
  bool isHide;
  bool name;
  bool pass;
  bool email;
  bool check;
 // bool checkPass;
  bool checkConfirm;

  UserState({
    this.isFacebookLoading = false,
    this.isGoogleLoading = false,
    this.isLoading = false,
    this.verificationId = '',
    this.phone = '',
    this.errorText,
    this.userModel,
    this.imageUrl,
    this.imagePath,
    this.name=true,
    this.pass=true,
    this.isHide=true,
    this.check=false,
    this.email=true,
    this.checkConfirm=true,
   // this.checkPass=true,
  });

  UserState copyWith(
      {bool? isGoogleLoading,
      bool? isFacebookLoading,
      bool? isLoading,
      String? errorText,
      String? phone,
      String? verificationId,
      UserModel? userModel,
      String? imageUrl,
       String? imagePath,
        bool? isHide,
        bool? name,
        bool? email,
        bool? pass,
        bool? check,
       // bool? checkPass,
        bool? checkConfirm,
      }) {
    return UserState(
      isFacebookLoading: isFacebookLoading ?? this.isFacebookLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText,
      phone: phone ?? this.phone,
      userModel: userModel ?? this.userModel,
      verificationId: verificationId ?? this.verificationId,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? imagePath,
      pass: pass ?? this.pass,
      name: name ?? this.name,
      isHide: isHide ?? this.isHide,
      check: check ?? this.check,
      email: email ?? this.email,
     // checkPass: checkPass ?? this.checkPass,
      checkConfirm: checkConfirm ?? this.checkConfirm
    );
  }
}
