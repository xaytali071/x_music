import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xmusic/viwe/app_widget.dart';
import 'controller/local_store.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocaleStore.init();
  runApp(const ProviderScope(child:  AppWidget()));
}
