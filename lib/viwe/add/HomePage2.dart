import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/viwe/add/add_new_author.dart';

import 'add_new_music.dart';



class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
            50.verticalSpace,
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                    create: (context) => AudioCubit(),
                    child: AddNewAuthorPage(),
                  )));
            }, child: Text("Add Author")),
            20.verticalSpace,
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                    create: (context) => AudioCubit(),
                    child: AddNewMusic(),
                  )));
            }, child: Text("Add Music"))
          ]
      ),
    );
  }
}
