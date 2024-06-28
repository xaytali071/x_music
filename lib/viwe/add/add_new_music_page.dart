import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/custom_text_form_field.dart';

class AddNewMusicPage extends StatefulWidget {
  final AuthorModel authorData;

  const AddNewMusicPage({super.key, required this.authorData});

  @override
  State<AddNewMusicPage> createState() => _AddNewMusicPageState();
}

class _AddNewMusicPageState extends State<AddNewMusicPage> {
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
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<AudioCubit, AudioState>(
          builder: (context, state) {
            return Column(
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
                state.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context
                              .read<AudioCubit>()
                              .getAudioUrl(trackUrl.text)
                              .then((value) {
                            context.read<AudioCubit>().addNewAudio(
                                trackName: trackName.text,
                                trackUrl: value ?? "",
                                artistId: widget.authorData.id ?? "",
                                onSuccess: () {
                                  trackUrl.clear();
                                  trackName.clear();
                                },
                                page: page.text,
                                artistName: widget.authorData.name ?? "");
                          });
                        },
                        child: Text("Add Music"))
              ],
            );
          },
        ));
  }
}
