import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';
import 'package:xmusic/model/coment_model.dart';
import 'package:xmusic/viwe/components/style.dart';

import '../../model/message_model.dart';
import '../../model/user_model.dart';
import '../local_store.dart';

class UserNotifire extends StateNotifier<UserState> {
  UserNotifire() : super(UserState());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker image = ImagePicker();
  String imgURl="";

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
        .doc(LocaleStore.getId())
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
        required String? fcm,
        required String? model,
      VoidCallback? onSuccess}) async {
    firestore
        .collection("users")
        .add(UserModel(
          name: name,
          password: password,
          email: email,
          avatar: avatar,
      fcm: fcm,
      model: model,
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
    await storageRef.putFile(File(imagePath));
    String imageUrl = await storageRef.getDownloadURL();
    imgURl=imageUrl;
    state = (state.copyWith(imageUrl: imageUrl));
    onSuccess?.call();
  }

  registrGoogle({required String? fcm,required String model,required VoidCallback? onSuccess}) async {
    try {
      state=(state.copyWith(isGoogleLoading: true));
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn().then((s){
        createUser(name: s?.displayName ?? "", password: s?.id ?? "", email: s?.email ?? "", avatar: s?.photoUrl, fcm: fcm, model: model);
        onSuccess?.call();
        state=(state.copyWith(isGoogleLoading: false,isLoading: false));
      });

    } catch (e) {
      if (kDebugMode) {
        state=(state.copyWith(isGoogleLoading: false,isLoading: false));
      }
      state=(state.copyWith(isGoogleLoading: false,isLoading: false));
    }

  }

  updateFcm(String fcm,VoidCallback onSuccess) async {
    state=(state.copyWith(isLoading: true));
    firestore.collection("users").doc(await LocaleStore.getId()).update({"fcmToken":fcm});
    state=(state.copyWith(isLoading: false));
    onSuccess.call();
  }

  reisterFacebook({required String? fcm,required String model,required VoidCallback? onSuccess}) async {
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
          fcm: fcm,
          model: model,
            ).toJson())
            .then((value) async {
          await LocaleStore.setId(value.id);
          onSuccess?.call();
        });
      } else {
        // sing up
        var res = await firestore
            .collection("users")
            .where("email", isEqualTo: userObj.user?.email)
            .get();

        if (res.docs.isNotEmpty) {
          await LocaleStore.setId(res.docs.first.id);
          onSuccess?.call();
        }
      }
    }

    state = (state.copyWith(isFacebookLoading: false));
  }

  deleteAccount(VoidCallback onSuccess) async {
     await firestore.collection("users").doc(LocaleStore.getId()).delete();
    await LocaleStore.storeClear();
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Style.primaryColor,
        textColor: Style.whiteColor,
        fontSize: 16.0);
    onSuccess();
  }

  logOut(VoidCallback onSuccess) async {
    await LocaleStore.storeClear();
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Style.primaryColor,
        textColor: Style.whiteColor,
        fontSize: 16.0);
    onSuccess();
  }

  loginGoogle({required VoidCallback? onSuccess}) async {
    try {
      state=(state.copyWith(isGoogleLoading: true));
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
     login(email: googleUser?.email ?? "", password: googleUser?.id ?? "");
      onSuccess?.call();
      state=(state.copyWith(isGoogleLoading: false,isLoading: false));
    } catch (e) {
      if (kDebugMode) {
        state=(state.copyWith(isGoogleLoading: false,isLoading: false));
      }
      state=(state.copyWith(isGoogleLoading: false,isLoading: false));
    }
  }

  loginFacebook({required VoidCallback? onSuccess}) async {
    state = (state.copyWith(isFacebookLoading: true));
    final fb = FacebookLogin();
    final user = await fb.logIn
      (permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);
    if (user.status == FacebookLoginStatus.success) {
      final OAuthCredential credential =
      FacebookAuthProvider.credential(user.accessToken?.token ?? "");

      final userObj =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userObj.additionalUserInfo?.isNewUser ?? true) {}
      login(email: userObj.user?.email ?? "", password: userObj.user?.uid ?? '',onSuccess: onSuccess?.call);

    }
  }

  editName({required String name, required VoidCallback onSuccess}) async {
    state=state.copyWith(isLoading: true);
      await firestore
          .collection("users")
          .doc(LocaleStore.getId())
          .update({'name': name});
      UserModel userModel=UserModel(
        name: name,
        email: state.userModel?.email,
        model: state.userModel?.model,
        avatar: state.userModel?.avatar,
      );
      state = state.copyWith(isLoading: false,userModel: userModel);
      onSuccess.call();

  }

  getImageGallery(VoidCallback onSuccess) async {
    await image.pickImage(source: ImageSource.gallery,imageQuality: 70).then((value) async {
      if (value != null) {
        CroppedFile? cropperImage =
            await ImageCropper().cropImage(sourcePath: value.path);
        state = (state.copyWith(imagePath: cropperImage?.path ?? ""));
        onSuccess();
      }
    });
  }

  sendFeedback({required String title}){
    state=state.copyWith(isLoading: true);
    firestore.collection("feedback").add(FeedbackModel(title: title, userId: LocaleStore.getId(),).toJson());
    state=state.copyWith(isLoading: false);
  }

  daleteMessage({required String id}){
    firestore.collection("users").doc(LocaleStore.getId()).collection("messages").doc(id).delete();
    print("daleted");
  }

  deleteFile({required String imagUrl}) async {
    Reference photoRef =await FirebaseStorage.instance.refFromURL(imagUrl);
    await photoRef.delete().then((value) {
      print('deleted Successfully');
    });
  }

  sendMessageImage({required String userId,
    required String title,
    required String image,
    required String body}) async {
    state = state.copyWith(isLoading: true);
    firestore.collection("users").doc(userId).collection("messages").add(
        MessageModel(
          //  userId: userId,
            title: title,
            time: DateTime.now(),
            image: image,

            body: body)
            .toJson());
    state = state.copyWith(isLoading: false);
  }

  getMessage() async {
    state=state.copyWith(isLoading: true);
    List<MessageModel> list=[];
    var res=await firestore.collection("users").doc(LocaleStore.getId()).collection("messages").get();
    int count=0;
    for(var element in res.docs){
      list.add(MessageModel.fromJson(element.data(), element.id));
    }
    list.sort(((a, b) => b.time!.compareTo(a.time!)));

    for(int i=0;i<list.length;i++){
      if(list[i].isRead==false){
        count+=1;
      }
      if(list.length>10){
        daleteMessage(id: list.last.id ?? "");
        deleteFile(imagUrl: list.last.image ?? "");
      }
    }

    state=state.copyWith(isLoading: false,listOfMessage: list,messageCount: count);
  }

  getMessages4() async {
    state=state.copyWith(isLoading: true);
    var res =await firestore
        .collection("users")
        .doc(LocaleStore.getId())
        .collection("messages").snapshots().listen((res){
      int count=0;
      List<MessageModel> list=[];
      for(var element in res.docs){
        list.add(MessageModel.fromJson(element.data(),element.id));
        if(element.data()["isRead"]==false){
          count+=1;
        }}
      if(list.length>10){
        daleteMessage(id: list.last.id ?? "");
        deleteFile(imagUrl: list.last.image ?? "");
      }
      state=state.copyWith(listOfMessage: list,isLoading: false,messageCount: count);

    });

  }

  readMessage({required String messageDocId}) async {
    await firestore
        .collection("users")
        .doc(LocaleStore.getId())
        .collection("messages").doc(messageDocId).update({"isRead":true});
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
        Fluttertoast.showToast(
            msg: "Email or password is incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Style.primaryColor,
            textColor: Style.whiteColor,
            fontSize: 16.0);
      }
    } catch (e) {
      state = (state.copyWith(
          errorText:
              "Password xatto bolishi mumkin yoki bunaqa nomer bn sign up qilinmagan",
          isLoading: false));
      Fluttertoast.showToast(
          msg: "Email or password is incorrect",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Style.primaryColor,
          textColor: Style.whiteColor,
          fontSize: 16.0);
    }
  }

  editImage({required VoidCallback onSuccess}) async {
    state=state.copyWith(isLoading: true);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("userImage/${DateTime.now().toString()}");
      await storageRef.putFile(File(state.imagePath ?? ""));

      String url = await storageRef.getDownloadURL();
      await firestore
          .collection("users")
          .doc(await LocaleStore.getId())
          .update({'avatar': url});

    UserModel userModel=UserModel(
      name: state.userModel?.name,
      email: state.userModel?.email,
      model: state.userModel?.model,
      avatar: state.imagePath,
    );
    deleteFile(imagUrl: state.userModel?.avatar ?? "");
    state=state.copyWith(isLoading: false,userModel: userModel);
      onSuccess.call();
  }


  hidePassword() {
    bool s=state.isHide;
    s=s=!s;
    state =state.copyWith(isHide: s);
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
    if (password==password2) {
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

  emptyImage(String s){
state=state.copyWith(emptyImage: s=="");
  }

  emptyName(String s){
    state=state.copyWith(emptyName: s=="");
  }
}
