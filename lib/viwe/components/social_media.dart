import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xmusic/viwe/components/button/mini_button.dart';
import 'package:xmusic/viwe/components/style.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});
  launchPinterest() async {
    var webUrl = "https://pl.pinterest.com/SilkRouteGlobalUK/";
    try {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  launchTelegram() async {
    var nativeUrl = "t.me/XaytaliNajmiddinov_blog";
    var webUrl = "https://t.me/XaytaliNajmiddinov_blog";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  // launchFaceBook() async {
  //   var nativeUrl = "facebook.com/shariatuz";
  //   var webUrl = "https://www.facebook.com/shariatuz";
  //   try {
  //     await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
  //   }
  // }

  // Future<void> launchInBrowser(Uri url) async {
  //   final Uri url = Uri.parse('https://silkrouteglobal.co.uk/');
  //   if (!await launchUrl(url)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  launchInstagram() async {
    var nativeUrl = "www.instagram.com/xaytali.najmiddinov/";
    var webUrl = "https://www.instagram.com/xaytali.najmiddinov/";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

  launchYouTube() async {
    var nativeUrl = "youtube.com/@XaytaliNajmiddinov";
    var webUrl = "https://www.youtube.com/@XaytaliNajmiddinov";

    try {
      await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    }
  }

//https://www.youtube.com/@Shariatuz
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        MiniButton(child: SvgPicture.asset("assets/you_tube.svg",color: Style.purple,width:25.r), onTap: (){
          launchYouTube();
        }),
        10.horizontalSpace,
        MiniButton(child: SvgPicture.asset("assets/instagram.svg",color: Style.purple,width: 22.r,), onTap: (){
          launchInstagram();
        }),
        10.horizontalSpace,
        MiniButton(child: Icon(Icons.telegram,color: Style.purple,size: 30.r,), onTap: (){
          launchTelegram();
        })

      ],
    );
  }
}