import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';

import '../../model/user_model.dart';
import '../localStore/local_store.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());
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
      emit(state.copyWith(isLoading: false));
      return false;
    }
  }

  sendSms(String phone, VoidCallback codeSend) async {
    emit(state.copyWith(isLoading: true, errorText: null));

    if (await checkPhone(phone)) {
      emit(state.copyWith(
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
          emit(state.copyWith(phone: phone, isLoading: false));
          codeSend();
          emit(state.copyWith(verificationId: verificationId));
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
    UserModel newModel = UserModel.fromJson(docId: res.id, data: res.data());
    emit(state.copyWith(userModel: newModel));
  }

  setUser(
      {required String name, required String phone, required String password}) {
    emit(state.copyWith(
        userModel: UserModel(
            name: name,
            username: '',
            password: password,
            email: "",
            phone: phone)));
  }

  checkCode(String code, VoidCallback onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId, smsCode: code);

      emit(state.copyWith(isLoading: false));

      onSuccess();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  createUser(VoidCallback onSuccess) async {
    firestore
        .collection("users")
        .add(UserModel(
      name: state.userModel?.name ?? "",
      username: state.userModel?.username ?? "",
      password: state.userModel?.password ?? "",
      email: state.userModel?.email ?? "",
      phone: state.userModel?.phone ?? "",
      avatar: state.userModel?.avatar,
    ).toJson())
        .then((value) async {
      await LocaleStore.setId(value.id);
      if (kDebugMode) {
        print("object 5");
      }
      onSuccess();
    });
  }

  loginGoogle(VoidCallback onSuccess) async {
    emit(state.copyWith(isGoogleLoading: true));
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
          username: userObj.user?.displayName ?? "",
          password: userObj.user?.uid ?? "",
          email: userObj.user?.email ?? "",
          phone: userObj.user?.phoneNumber ?? "",
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

    emit(state.copyWith(isGoogleLoading: false));
  }

  loginFacebook(VoidCallback onSuccess) async {
    emit(state.copyWith(isFacebookLoading: true));
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
          username: userObj.user?.displayName ?? "",
          password: userObj.user?.uid ?? "",
          email: userObj.user?.email ?? "",
          phone: userObj.user?.phoneNumber ?? "",
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

    emit(state.copyWith(isFacebookLoading: false));
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
        username: state.userModel?.username,
        password: state.userModel?.password,
        email: state.userModel?.email,
        phone: state.userModel?.phone,
      );
      onSuccess();

      emit(state.copyWith(userModel: userModel));
    }
  }

  getImageGallery(VoidCallback onSuccess) async {
    await image.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
        await ImageCropper().cropImage(sourcePath: value.path);
        emit(state.copyWith(imagePath: cropperImage?.path));
        onSuccess();
      }
      // emit(state.copyWith(image: state.imagePath));
    });

    // notifyListeners();
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

  changePhone(bool isEmpty) {
    state.phonee = isEmpty;
    if (state.phonee == false && state.name == false && state.pass == false) {
      emit(state.copyWith(check: true));
    }
    else {
      emit(state.copyWith(check: false));
    }
  }

  changeName(bool isEmpty) {
    state.name = isEmpty;
    if (state.phonee == false && state.name == false && state.pass == false) {
      emit(state.copyWith(check: true));
    }
    else {
      emit(state.copyWith(check: false));
    }
  }

  changePass(bool isEmpty,) {
    state.pass = isEmpty;
    if (state.phonee == false && state.name == false && state.pass == false) {
      emit(state.copyWith(check: true));
    }
    else {
      emit(state.copyWith(check: false));
    }
  }

  checkPassword(String password){
    if(password.length<8){
      emit(state.copyWith(check: false));
    }
    else{
      emit(state.copyWith(check: true));
    }
  }
}