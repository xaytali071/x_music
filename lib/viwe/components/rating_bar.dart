
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/style.dart';

class CustomRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  const CustomRatingBar({super.key, required this.rating,this.size=12 });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: RatingBar.builder(
            initialRating: rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            unratedColor: Style.greyColor,
            itemSize: size.r,
            tapOnlyMode: true,
            updateOnDrag: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (r) {
            },
          ),
        ),
        Positioned(
          child: Container(
            width: 70.w,
            height: 20.h,
            color: Style.transperntColor,
          ),
        )
      ],
    );
  }
}