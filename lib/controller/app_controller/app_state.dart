class AppState{
  bool darkMode;
  int selectIndex;
  AppState({this.darkMode=false,this.selectIndex=0});

  AppState copyWith({
    bool? darkMode,
    int? selectIndex,
})=>AppState(
    darkMode: darkMode ?? this.darkMode,
    selectIndex: selectIndex ?? this.selectIndex,
  );
}