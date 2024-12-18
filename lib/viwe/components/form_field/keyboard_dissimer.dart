import 'package:flutter/material.dart';

class KeyboardDissimer extends StatelessWidget {
  final Widget child;
  const KeyboardDissimer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}