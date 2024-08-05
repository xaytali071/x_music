import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/viwe/components/image/custom_network_image.dart';
import 'package:xmusic/viwe/components/form_field/custom_text_form_field.dart';

import '../../controller/providers.dart';

class AddNewAuthorPage extends ConsumerStatefulWidget {
  const AddNewAuthorPage({super.key});

  @override
  ConsumerState<AddNewAuthorPage> createState() => _AddNewAuthorPageState();
}

class _AddNewAuthorPageState extends ConsumerState<AddNewAuthorPage> {

  TextEditingController name=TextEditingController();
  TextEditingController image=TextEditingController();
  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.read(audioProvider);
    final event = ref.read(audioProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
            child: Column(
              children: [
                watch.imagePath == ""
                    ? ElevatedButton(onPressed: () {
                      event.getImageGallery(() { });
                }, child: Text("Galerey"))
                    : GestureDetector(
                    onTap: (){
                      event.getImageGallery(() { });
                    },
                    child: CustomImage(url: watch.imagePath)),
                CustomTextFormField(hint: "Author name",controller: name,),
                20.verticalSpace,
                watch.isLoading ? const CircularProgressIndicator() :
                ElevatedButton(onPressed: () {
                  event.createImageUrl(imagePath: watch.imagePath,onSuccess: (){
                    event.addNewAuthor(name: name.text,imagePath: watch.imagePath ?? "");
                  });
                }, child: Text("Add"))
              ],
            ),
          )
    );
  }
}
