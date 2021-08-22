import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/screens/settings.dart';
import 'package:flutter_chat_ui/services/auth.dart';
import 'package:flutter_chat_ui/services/database.dart';
import 'package:flutter_chat_ui/widgets/category_selector.dart';
import 'package:flutter_chat_ui/widgets/favorite_contacts.dart';
import 'package:flutter_chat_ui/widgets/recent_chats.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    return StreamProvider<List<User>>.value(
      value: DatabaseService().favUser,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            CategorySelector(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    FavoriteContacts(),
                    RecentChats(),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Options',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () async {
                  await _auth.signOut();
                  // Update the state of the app.
                  Navigator.pop(context);
                  // ...
                },
              ),
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Settings(
                        userUid: user.uid,
                      ),
                    ),
                  );

                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
