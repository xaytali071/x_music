import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/image/custom_network_image.dart';
import '../../../components/style.dart';

class MessageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  const MessageWidget({super.key, required this.image, required this.title, required this.body, required this.time, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return  DecoratedBox(
      decoration: BoxDecoration(
          color: Style.whiteColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.all(5.r),
                child: SizedBox(
                    width: 350.w,
                    child: Text(title,style: Style.normalText(),maxLines: 2,overflow: TextOverflow.ellipsis,)),
              ),
              image=="" ? SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 10.h,
              ) :
              CustomImageNetwork(image:image,height: 150,radius: 0,),
              Padding(
                padding:  EdgeInsets.all(5.r),
                child: SizedBox(
                    width: 350.w,
                    child: Text(body,style: Style.miniText(color: Style.greyColor),maxLines: 2,overflow: TextOverflow.ellipsis,)),
              ),
              10.verticalSpace,
            ],
          ),
          Positioned(
              right: 0,
              child: isRead ? SizedBox.shrink() : Icon(Icons.circle,color: Style.redColor,size: 10.r,) ),
          Positioned(
              bottom: 3,
              right: 7,
              child: Text(time.substring(0,16),style: Style.miniText(),))
        ],
      ),
    );
  }
}