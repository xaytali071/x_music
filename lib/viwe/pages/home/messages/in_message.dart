import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import '../../../components/image/custom_network_image.dart';
import '../../../components/style.dart';

class InMessagePage extends ConsumerStatefulWidget {
  final String image;
  final String title;
  final String body;
  final String time;
  final String id;

  const InMessagePage({super.key, required this.image, required this.title, required this.body, required this.time, required this.id});

  @override
  ConsumerState<InMessagePage> createState() => _InMessagePageState();
}

class _InMessagePageState extends ConsumerState<InMessagePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userProvider.notifier).readMessage(messageDocId:widget.id);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  BackGroundWidget(
      child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            widget.image=="" ? SizedBox(height: 10.h,) :
            Padding(
              padding:  EdgeInsets.all(4.r),
              child: CustomImageNetwork(image: widget.image,height: 300,),
            ),
            10.verticalSpace,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(widget.body,style: Style.normalText(),),
            ),
          ],
        ),
      ),
    );
  }
}