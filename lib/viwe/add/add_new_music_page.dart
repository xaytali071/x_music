import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';

import '../../controller/providers.dart';
import '../components/custom_drop_down.dart';

class AddNewMusicPage extends ConsumerStatefulWidget {
  final AuthorModel authorData;

  const AddNewMusicPage({super.key, required this.authorData});

  @override
  ConsumerState<AddNewMusicPage> createState() => _AddNewMusicPageState();
}

class _AddNewMusicPageState extends ConsumerState<AddNewMusicPage> {
  TextEditingController trackUrl = TextEditingController();
  TextEditingController trackName = TextEditingController();
  String ganre="";
  String collection="music";
  @override
  void initState() {
    print(widget.authorData);
    super.initState();
  }

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
                  CustomTextFormField(
                    hint: "Track Name",
                    controller: trackName,
                  ),
                  30.verticalSpace,
                  CustomTextFormField(
                    hint: "Track Url",
                    controller: trackUrl,
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

                              event.addNewAudio(
                                  trackName: trackName.text,
                                  trackUrl: trackUrl.text,
                                  artistImage: widget.authorData.image ?? "",
                                  ganre: ganre,
                                  collection: collection,
                                  onSuccess: () {
                                    trackUrl.clear();
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
