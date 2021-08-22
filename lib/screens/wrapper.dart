import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:flutter_chat_ui/screens/authenticate/authenticate.dart';
import 'package:flutter_chat_ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
