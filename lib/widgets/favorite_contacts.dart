import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:flutter_chat_ui/models/message_model.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:flutter_chat_ui/services/database.dart';
import 'package:flutter_chat_ui/shared/loading.dart';
import 'package:provider/provider.dart';

class FavoriteContacts extends StatefulWidget {
  @override
  _FavoriteContactsState createState() => _FavoriteContactsState();
}

class _FavoriteContactsState extends State<FavoriteContacts> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    return StreamBuilder<List<User>>(
        stream: DatabaseService().favUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User> fav = snapshot.data;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Favorite Contacts',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                          ),
                          iconSize: 30.0,
                          color: Colors.blueGrey,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 120.0,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: fav.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                userUid: user.uid,
                                friendUser: fav[index],
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(
                                      fav[index].imageUrl ??
                                          favorites[index].imageUrl),
                                ),
                                SizedBox(height: 6.0),
                                Text(
                                  fav[index].name,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
