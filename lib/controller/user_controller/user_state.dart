import '../../model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_state.freezed.dart';
@freezed
class UserState with _$UserState {

  const factory UserState({

  @Default(false)  bool isGoogleLoading,
    @Default(false)  bool isFacebookLoading,
    @Default(false)  bool isLoading,
    UserModel? userModel,
    @Default("")  String verificationId,
    @Default("")  String phone,
    @Default("") String errorText,
    @Default("")   String imageUrl,
    @Default("") String imagePath,
    @Default(false) bool isHide,
    @Default(false) bool name,
    @Default(false) bool pass,
    @Default(false)  bool email,
    @Default(false)  bool check,
    @Default(false) bool emptyImage,
  @Default(false) bool emptyName,

    // bool checkPass,
    @Default(false)  bool checkConfirm,
  })=_UserState;

}