import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';

import '../../model/user_model.dart';
import '../localStore/local_store.dart';

class UserNotifire extends StateNotifier<UserState> {
  UserNotifire() : super(UserState());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker image = ImagePicker();

  Future<bool> checkPhone(String phone) async {
    try {
      var res = await firestore
          .collection("users")
          .where("phone", isEqualTo: phone)
          .get();
      // ignore: unnecessary_null_comparison
      if (res.docs.first != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      state = (state.copyWith(isLoading: false));
      return false;
    }
  }

  sendSms(String phone, VoidCallback codeSend) async {
    state = (state.copyWith(isLoading: true, errorText: ""));

    if (await checkPhone(phone)) {
      state = (state.copyWith(
          errorText: "Bu raqamga avval hisob ochilgan", isLoading: false));
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          if (kDebugMode) {
            print(credential.toString());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            print(e.toString());
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          state = (state.copyWith(phone: phone, isLoading: false));
          codeSend();
          state = (state.copyWith(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  getUser() async {
    var res = await firestore
        .collection("users")
        .doc(await LocaleStore.getId())
        .get();
    UserModel newModel = UserModel.fromJson(data: res.data());
    state = (state.copyWith(userModel: newModel));
  }

  checkCode(String code, VoidCallback onSuccess) async {
    state = (state.copyWith(isLoading: true));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId, smsCode: code);

      state = (state.copyWith(isLoading: false));

      onSuccess();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  createUser(
      {required String name,
      required String password,
      required String email,
      required String? avatar,
      VoidCallback? onSuccess}) async {
    firestore
        .collection("users")
        .add(UserModel(
          name: name,
          password: password,
          email: email,
          avatar: avatar,
        ).toJson())
        .then((value) async {
      await LocaleStore.setId(value.id);

      onSuccess?.call();
    });
  }

  createImageUrl({required String imagePath, VoidCallback? onSuccess}) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("musicImage/${DateTime.now().toString()}");
    await storageRef.putFile(File(imagePath ?? ""));

    String imageUrl = await storageRef.getDownloadURL();
    state = (state.copyWith(imageUrl: imageUrl));
    onSuccess?.call();
  }

  loginGoogle(VoidCallback onSuccess) async {
    state = (state.copyWith(isGoogleLoading: true));
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser?.authentication != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userObj =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("${userObj.additionalUserInfo?.isNewUser}");
      if (userObj.additionalUserInfo?.isNewUser ?? true) {
        // sing in
        firestore
            .collection("users")
            .add(UserModel(
              name: userObj.user?.displayName ?? "",
              password: userObj.user?.uid ?? "",
              email: userObj.user?.email ?? "",
              avatar: userObj.user?.photoURL ?? "",
            ).toJson())
            .then((value) async {
          await LocaleStore.setId(value.id);
          onSuccess();
          googleSignIn.signOut();
        });
      } else {
        // sing up
        var res = await firestore
            .collection("users")
            .where("email", isEqualTo: userObj.user?.email)
            .get();

        if (res.docs.isNotEmpty) {
          await LocaleStore.setId(res.docs.first.id);
          onSuccess();
        }
      }
    }

    state = (state.copyWith(isGoogleLoading: false));
  }

  loginFacebook(VoidCallback onSuccess) async {
    state = (state.copyWith(isFacebookLoading: true));
    final fb = FacebookLogin();
    final user = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);
    if (user.status == FacebookLoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(user.accessToken?.token ?? "");

      final userObj =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userObj.additionalUserInfo?.isNewUser ?? true) {
        // sing in
        firestore
            .collection("users")
            .add(UserModel(
              name: userObj.user?.displayName ?? "",
              password: userObj.user?.uid ?? "",
              email: userObj.user?.email ?? "",
              avatar: userObj.user?.photoURL ?? "",
            ).toJson())
            .then((value) async {
          await LocaleStore.setId(value.id);
          onSuccess();
        });
      } else {
        // sing up
        var res = await firestore
            .collection("users")
            .where("email", isEqualTo: userObj.user?.email)
            .get();

        if (res.docs.isNotEmpty) {
          await LocaleStore.setId(res.docs.first.id);
          onSuccess();
        }
      }
    }

    state = (state.copyWith(isFacebookLoading: false));
  }

  logOut(VoidCallback onSuccess) async {
    await firestore.collection("users").doc(await LocaleStore.getId()).delete();
    await LocaleStore.storeClear();
    onSuccess();
  }

  editName({required String name, required VoidCallback onSuccess}) async {
    if (name.isNotEmpty) {
      await firestore
          .collection("users")
          .doc(await LocaleStore.getId())
          .update({'name': name});

      UserModel userModel = UserModel(
        name: name,
        password: state.userModel?.password,
        email: state.userModel?.email,
      );
      onSuccess();

      state = (state.copyWith(userModel: userModel));
    }
  }

  getImageGallery(VoidCallback onSuccess) async {
    await image.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        state = (state.copyWith(imagePath: cropperImage?.path ?? ""));
        onSuccess();
      }
    });
  }

  login(
      {required String email,
      required String password,
      VoidCallback? onSuccess}) async {
    state = (state.copyWith(errorText: "", isLoading: true));
    try {
      var res = await firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      if (res.docs.first["password"] == password) {
        LocaleStore.setId(res.docs.first.id);
        onSuccess?.call();
        state = (state.copyWith(isLoading: false));
      } else {
        state = (state.copyWith(
            errorText:
                "Password xatto bolishi mumkin yoki bunaqa nomer bn sign up qilinmagan",
            isLoading: false));
      }
    } catch (e) {
      state = (state.copyWith(
          errorText:
              "Password xatto bolishi mumkin yoki bunaqa nomer bn sign up qilinmagan",
          isLoading: false));
    }
  }

  editImage(VoidCallback onSuccess) async {
    await getImageGallery(() async {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("userImage/${DateTime.now().toString()}");
      await storageRef.putFile(File(state.imagePath ?? ""));

      String url = await storageRef.getDownloadURL();
      await firestore
          .collection("users")
          .doc(await LocaleStore.getId())
          .update({'avatar': url});
      onSuccess();
    });
  }

  hidePassword() {
    state = (state.copyWith(isHide: state.isHide !=state.isHide));
  }

  changeName(bool isEmpty) {
    state.name == isEmpty;
    if (state.email == false &&
        state.name == false &&
        state.pass == false &&
        state.checkConfirm == false) {
      state = (state.copyWith(check: true));
    } else {
      state = (state.copyWith(check: false));
    }
  }

  checkConfirmPassword(String password, String password2) {
 //   state.checkConfirm = password == password2;
    print(state.checkConfirm);
    if (state.email == false &&
        state.name == false &&
        state.pass == false &&
        state.checkConfirm == false) {
      state = (state.copyWith(check: true, errorText: ""));
    } else {
      state =
          (state.copyWith(check: false, errorText: "Passwords do not match"));
    }
  }

  checkPassword(String password) {
    state.pass == password.length < 8;
    print(state.pass);
    if (state.email == false &&
        state.name == false &&
        state.pass == false &&
        state.checkConfirm == false) {
      state = (state.copyWith(
        check: true,
      ));
    } else if (password.length < 8) {
      state = (state.copyWith(check: false, errorText: "Inviled password"));
    } else {
      state = (state.copyWith(check: false, errorText: ""));
    }
  }

  changeEmail(bool isEmpty) {
    state.email == isEmpty;
    if (state.email == false &&
        state.name == false &&
        state.pass == false &&
        state.checkConfirm == false) {
      state = (state.copyWith(check: true));
    } else {
      state = (state.copyWith(check: false));
    }
  }

  errorText(String text) {
    state = (state.copyWith(errorText: text));
  }
}
