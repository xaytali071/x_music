import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xmusic/controller/app_controller/app_cubit.dart';
import 'package:xmusic/controller/app_controller/app_state.dart';
import 'package:xmusic/controller/audio_state/audio_cubit.dart';
import 'package:xmusic/controller/audio_state/audio_state.dart';
import 'package:xmusic/controller/user_controller/user_cubit.dart';
import 'package:xmusic/controller/user_controller/user_state.dart';

final audioProvider=StateNotifierProvider<AudioNotifire,AudioState>((ref) => AudioNotifire());
final appProvider=StateNotifierProvider<AppNotifire,AppState>((ref) => AppNotifire());
final userProvider=StateNotifierProvider<UserNotifire,UserState>((ref) => UserNotifire());