import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';

import '../local_store.dart';

class AppNotifire extends StateNotifier<AppState>{
  AppNotifire() : super(AppState());

  darkMode(bool value){
    LocaleStore.setMode(value);
    state=(state.copyWith(darkMode: LocaleStore.getMode()));
  }

  getMode(){
   state=(state.copyWith(darkMode: LocaleStore.getMode()));
  }

  selIndex(int index){
    state=(state.copyWith(selectIndex: index));
  }

}