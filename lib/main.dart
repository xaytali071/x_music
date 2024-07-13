import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xmusic/controller/localStore/local_store.dart';
import 'package:xmusic/viwe/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocaleStore.init();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      importance: NotificationImportance.Min,
        channelKey: "music", channelName: "musicN", channelDescription: "1111")
  ]);
  runApp(const ProviderScope(child:  AppWidget()));
}
