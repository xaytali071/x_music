import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState{
  const factory AppState({
    @Default(false) bool darkMode,
    @Default(0) int selectIndex,
  })=_AppState;
}