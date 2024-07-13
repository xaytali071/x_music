import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/viwe/components/custom_text_form_field.dart';

import '../../controller/providers.dart';

class AddNewMusicPage extends ConsumerStatefulWidget {
  final AuthorModel authorData;

  const AddNewMusicPage({super.key, required this.authorData});

  @override
  ConsumerState<AddNewMusicPage> createState() => _AddNewMusicPageState();
}

class _AddNewMusicPageState extends ConsumerState<AddNewMusicPage> {
  TextEditingController trackUrl = TextEditingController();
  TextEditingController trackName = TextEditingController();
  TextEditingController page = TextEditingController();
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
        body:  Column(
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
                CustomTextFormField(hint: "Page",controller:page,keyBoardType: TextInputType.number,),
                30.verticalSpace,
                watch.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {

                            event.addNewAudio(
                                trackName: trackName.text,
                                trackUrl: trackUrl.text,
                                artistId: widget.authorData.id ?? "",
                                onSuccess: () {
                                  trackUrl.clear();
                                  trackName.clear();
                                },
                                page: page.text,
                                artistName: widget.authorData.name ?? "");

                        },
                        child: Text("Add Music"))
              ],
            )
         );
  }
}
