import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:xmusic/controller/local_store.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/auth/register_page.dart';

import '../bottom_bar.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  
  goto(){
    Future.delayed(const Duration(milliseconds: 900)).then((s){
      if(LocaleStore.getId()==null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const RegisterPage()), (_)=>false);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const BottomBar()), (_)=>false);
      }
    });
  }

  int rating=0;
  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [100, 200, 130, 180, 150];
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((d){
      ref.read(appProvider.notifier).getMode();
    });
    goto();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.blackColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png",width: 170.r,height: 170.r,),
            20.verticalSpace,
             SizedBox(
               height: 40.h,
               width: 300.w,
               child: MusicVisualizer(
                 barCount: 30,
                 colors: colors,
                 duration: duration,
               ),
             ),
          ],
        ),
      ),
    );
  }
}
