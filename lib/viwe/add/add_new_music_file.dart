
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/custom_drop_down.dart';

import '../../controller/audio_state/audio_state.dart';
import '../../controller/providers.dart';
import '../../model/author_model.dart';
import '../components/form_field/custom_text_form_field.dart';

class AddNewMusicFile extends ConsumerStatefulWidget {
  final AuthorModel authorData;
  const AddNewMusicFile({super.key,required this.authorData,});

  @override
  ConsumerState<AddNewMusicFile> createState() => _AddNewMusicFileState();
}

class _AddNewMusicFileState extends ConsumerState<AddNewMusicFile> {

  String ganre="";
  String collection="music";
  TextEditingController trackName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    return Scaffold(
        appBar: AppBar(),
        body:  Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              ElevatedButton(onPressed: (){
                event.getFile(onSuccess: (){});
              }, child: Text("File")),
              20.verticalSpace,
              CustomTextFormField(
                hint: "Track Name",
                controller: trackName,
              ),
              30.verticalSpace,
             CustomDropDown(hint: "Janr",list: ["Pop","Rep","Rok","Jaz","Audio kitob","Podcast","Intervyu"],onChanged: (a){
              ganre=a;
            },),
          30.verticalSpace,
              CustomDropDown(list: ["music","audioBook","podcast","intervyu"],hint: "Collection",onChanged: (s){
                collection=s;
              },),
              30.verticalSpace,
              watch.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: () {

                    event.addNewAudioFile(
                      collection: collection,
                        trackName: trackName.text,
                        filePath: watch.filePath,
                        artistImage: widget.authorData.image ?? "",
                          ganre: ganre,
                        onSuccess: () {
                          trackName.clear();
                        },
                        artistName: widget.authorData.name ?? "");

                  },
                  child: Text("Add Music"))
            ],
          ),
        )
    );
  }
}
