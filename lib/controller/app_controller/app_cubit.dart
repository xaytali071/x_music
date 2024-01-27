import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/localStore/local_store.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppState());

  darkMode(bool value){
    LocaleStore.setMode(value);
    emit(state.copyWith(darkMode: LocaleStore.getMode()));
  }

  getMode(){
   emit(state.copyWith(darkMode: LocaleStore.getMode()));
  }

  selIndex(int index){
    emit(state.copyWith(selectIndex: index));
  }

}