import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:flutter_chat_ui/screens/wrapper.dart';
import 'package:flutter_chat_ui/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FireUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Chat UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue[200],
          accentColor: Color(0xFFFEF9EB),
        ),
        home: Wrapper(),
      ),
    );
  }
}
