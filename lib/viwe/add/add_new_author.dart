import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';
import 'package:xmusic/viwe/components/custom_text_form_field.dart';

class AddNewAuthorPage extends StatefulWidget {
  const AddNewAuthorPage({super.key});

  @override
  State<AddNewAuthorPage> createState() => _AddNewAuthorPageState();
}

class _AddNewAuthorPageState extends State<AddNewAuthorPage> {

  TextEditingController name=TextEditingController();
  TextEditingController image=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AudioCubit, AudioState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                state.imagePath == null
                    ? ElevatedButton(onPressed: () {
                      context.read<AudioCubit>().getImageGallery(() { });
                }, child: Text("Galerey"))
                    : CustomImage(url: state.imagePath),
                CustomTextFormField(hint: "Author name",controller: name,),
                20.verticalSpace,
                state.isLoading ? CircularProgressIndicator() :
                ElevatedButton(onPressed: () {
                  context.read<AudioCubit>().createImageUrl(imagePath: state.imagePath ?? "",onSuccess: (){
                    context.read<AudioCubit>().addNewAuthor(name: name.text,imagePath: state.imagePath ?? "");
                  });
                }, child: Text("Add"))
              ],
            ),
          );
        },
      ),
    );
  }
}
