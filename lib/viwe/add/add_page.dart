import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/aud/audio_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xmusic/model/music_model.dart';

import '../../controller/audio_state/audio_cubit.dart';
import '../pages/home/home_page.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController authorController = TextEditingController();
  TextEditingController trackNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  late File filePath;
  String? imagePath;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imagePath == null
                    ? const SizedBox.shrink()
                    : Image.file(File(imagePath!)),
                TextFormField(
                  controller: trackNameController,
                  decoration: const InputDecoration(labelText: "trackName"),
                ),
                TextFormField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: "author"),
                ),

                ElevatedButton(onPressed: () async {
                  FilePickerResult? audioPath = await FilePicker.platform
                      .pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', "oog", "ma4", "waw"],
                  );
                }, child: const Text("Chiqar")),

                ElevatedButton(
                    onPressed: () async {
                      final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                      imagePath = image?.path;
                      setState(() {});
                    },
                    child: const Text("galereya")),
                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                      if (result != null) {
                        filePath = File(result.files.single.path!);
                      } else {
                        // User canceled the picker
                      }
                      setState(() {});
                    },
                    child: const Text("audio")),

                70.verticalSpace,
                ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});
                      final storag = FirebaseStorage.instance
                          .ref()
                          .child("music/${DateTime.now()}");
                      await storag.putFile(filePath);
                      String musicUrl = await storag.getDownloadURL();

                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child("musicImage/${DateTime.now().toString()}");
                      await storageRef.putFile(File(imagePath ?? ""));

                      String imageUrl = await storageRef.getDownloadURL();

                      firestore
                          .collection("music")
                          .add(MusicModel(
                          image: imageUrl,
                          artist: authorController.text,
                          trackName: trackNameController.text,
                          track: musicUrl)
                          .toJson())
                          .then((value) {
                        isLoading = false;
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => AudioCubit(),
                                        ),
                                        BlocProvider(
                                          create: (context) => AppCubit(),
                                        ),
                                      ],
                                      child: HomePage(),
                                    )));
                      });
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}