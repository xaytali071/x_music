import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/add/add_new_author.dart';
import 'package:xmusic/viwe/components/custom_text_form_field.dart';

import 'add_new_music.dart';



class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  TextEditingController url=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
            50.verticalSpace,
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  AddNewAuthorPage()));
            }, child: Text("Add Author")),
            20.verticalSpace,
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) =>
                  AddNewMusic()));
            }, child: Text("Add Music")),


          ]
      ),
    );
  }
}
