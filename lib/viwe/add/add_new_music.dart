
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/viwe/add/add_new_music_page.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';

import '../../controller/providers.dart';

class AddNewMusic extends ConsumerStatefulWidget {
  const AddNewMusic({super.key});

  @override
  ConsumerState<AddNewMusic> createState() => _AddNewMusicState();
}

class _AddNewMusicState extends ConsumerState<AddNewMusic> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(audioProvider.notifier).getAuthor();
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: watch.isLoading ? CircularProgressIndicator() : Expanded(
            child: ListView.builder(
                itemCount: watch.listOfAuthor.length ,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>AddNewMusicPage(authorData: watch.listOfAuthor![index],)));
                    },
                    child: SizedBox(
                      width: 200.w,
                      height: 235.h,
                      child: Column(
                        children: [
                          CustomImage(url:watch.listOfAuthor[index].image,height: 200,width: 200,),
                          Text(watch.listOfAuthor[index].name ?? ""),
                        ],
                      ),
                    ),
                  );
                }),
          )
    );
  }
}
