import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/viwe/components/shimmer_item.dart';

class CustomImageNetwork extends StatelessWidget {
  final String? image;
  final double height;
  final double width;
  final double radius;
  final BoxFit boxFit;
  final Widget child;

  const CustomImageNetwork(
      {Key? key,
        required this.image,
        this.height = 120,
        this.width = double.infinity,
        this.radius = 8,
        this.boxFit = BoxFit.cover,
        this.child = const SizedBox.shrink()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        height: height.h,
        width: width.w,
        fit: boxFit,
        imageUrl: image ?? "",
        progressIndicatorBuilder: (context, text, DownloadProgress value) {
          return ShimmerItem(height: height.h, width: width.w, radius: radius.r);
        },
        errorWidget: (context, _, __) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}


class CustomImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit boxFit;

  const CustomImage({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.radius = 12,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: url?.isEmpty ?? true
          ? Container(
        height: height?.r,
        width: width?.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.r),
        ),
        alignment: Alignment.center,
      )
          : url!.contains("assets/")
          ? ClipRRect(
          borderRadius: BorderRadius.circular(radius.r),
          child: Image.asset(
            url!,
            height: height?.r,
            width: width?.r,
            fit: boxFit,
          ))
          : url?.contains("http") ?? true
          ? CachedNetworkImage(
        height: height?.r,
        width: width?.r,
        imageUrl: url ?? "",
        fit: boxFit,
        progressIndicatorBuilder: (context, url, progress) {
          return Container(
            height: height?.r,
            width: width?.r,
            decoration: const BoxDecoration(),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.r),
            ),
            alignment: Alignment.center,
          );
        },
      )
          : Image.file(
        File(url ?? ""),
        height: height?.r,
        width: width?.r,
        fit: boxFit,
      ),
    );
  }
}