import 'package:flutter/material.dart';
import 'package:xmusic/viwe/components/blur_wrap.dart';
import 'package:xmusic/viwe/components/style.dart';

class InBackGroundWidget extends StatefulWidget {
  final Widget child;
  final String image;
  const InBackGroundWidget({super.key, required this.child, required this.image});

  @override
  State<InBackGroundWidget> createState() => _BackGroundWidgetState();
}

class _BackGroundWidgetState extends State<InBackGroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.whiteColor,
      body: SingleChildScrollView(
        child: BlurWrap(
          radius: BorderRadius.circular(1),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration:  BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.image,scale:0.2),
                    fit: BoxFit.cover
                )
            ),
            child:widget.child,
          ),
        ),
      ),
    );
  }
}