import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/viwe/pages/home/muz.dart';
import 'package:xmusic/viwe/pages/home/search_page.dart';

import '../../controller/audio_state/audio_state.dart';
import '../../controller/providers.dart';
import '../../controller/user_controller/user_state.dart';
import '../components/style.dart';
import 'home/dwower_widget.dart';
import 'home/home_page.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  void initState() {
    selIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((s){
      ref.read(audioProvider.notifier).fetchMusic();
      ref.read(userProvider.notifier).getUser();
      ref.read(userProvider.notifier).getMessages4();
    });
    super.initState();
  }

  List<Widget> listOfPage=[HomePage(),SearchPage()];

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    UserState watch1 = ref.watch(userProvider);
    bool mode=ref.watch(appProvider).darkMode;
    return Scaffold(
      key: _key,
      endDrawerEnableOpenDragGesture: false,
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget(
        dkey: _key,
        userInfo: watch1.userModel,
      ),
      body: listOfPage[ref.watch(appProvider).selectIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          watch.selectIndex == -1
              ? const SizedBox.shrink() : MuicWidget(list:watch.isSearchList ? watch.listOfSearchRes : watch.listOfMusic) ,
          BottomNavigationBar(
            backgroundColor: mode ? Style.blackColor : Style.whiteColor,
      selectedItemColor: Style.purple,
            unselectedItemColor: mode ? Style.whiteColor50 : Style.blackColor50,
            selectedIconTheme: IconThemeData(size: 25.r),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            currentIndex: ref.watch(appProvider).selectIndex,
            onTap: (s){
              ref.read(appProvider.notifier).selIndex(s);
            },
            items: const[
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search")
            ],
          ),
        ],
      ),
    );
  }
}
