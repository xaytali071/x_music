
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/model/author_model.dart';
import 'package:xmusic/viwe/add/add_new_music_page.dart';
import 'package:xmusic/viwe/components/custom_network_image.dart';

class AddNewMusic extends StatefulWidget {
  const AddNewMusic({super.key});

  @override
  State<AddNewMusic> createState() => _AddNewMusicState();
}

class _AddNewMusicState extends State<AddNewMusic> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AudioCubit>().getAuthor();
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AudioCubit, AudioState>(
        builder: (context, state) {
          return  state.isLoading ? CircularProgressIndicator() : Expanded(
            child: ListView.builder(
                itemCount: state.listOfAuthor?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>BlocProvider(
                        create: (context) => AudioCubit(),
                        child: AddNewMusicPage(authorData: state.listOfAuthor![index],),
                      )));
                    },
                    child: SizedBox(
                      width: 200.w,
                      height: 235.h,
                      child: Column(
                        children: [
                          CustomImage(url:state.listOfAuthor?[index].image,height: 200,width: 200,),
                          Text(state.listOfAuthor?[index].name ?? ""),
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
