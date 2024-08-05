import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

class NotificationWidget extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  final Color color;
  const NotificationWidget({super.key, required this.count, required this.onTap,required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 35.r,
        height: 35.r,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: color,
              size: 30.r,
            ),
            Positioned(
              right: 8.r,
              top: 0.r,
              child: count==0 ? SizedBox.shrink() : Container(
                width: 15.r,
                height: 15.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Style.redColor,
                ),
                child: Center(child: Text(count.toString(),style: Style.miniText(size: 7,weight: FontWeight.w600,color: Style.whiteColor),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}