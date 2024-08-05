import 'package:shared_preferences/shared_preferences.dart';

class LocaleStore {
  LocaleStore._();


  static SharedPreferences? store;

  static Future init() async {
    store = await SharedPreferences.getInstance();
  }

  static setId(String id) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.setString("id", id);
  }

  static getId()=> store?.getString("id");


  static setMode(bool value) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.setBool("mode", value);
  }

  static getMode()=> store?.getBool("mode") ?? false;

  static storeClear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}