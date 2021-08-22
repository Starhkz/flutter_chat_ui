import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/fire_user.dart';
import 'package:flutter_chat_ui/models/message_model.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/screens/chat_screen.dart';
import 'package:flutter_chat_ui/services/database.dart';
import 'package:flutter_chat_ui/shared/loading.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
    String friendName;
    final user = Provider.of<FireUser>(context);
    return StreamBuilder<List<Chat>>(
        stream: DatabaseService(uid: user.uid).chatList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Chat> chat = snapshot.data;
            if (chat.isNotEmpty) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chat.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Chat myChats = chat[index];
                        return GestureDetector(
                          onTap: () {
                            print(myChats.chatUid);
                            DatabaseService(uid: user.uid)
                                .updateChatList(myChats.time, false);
                            DatabaseService(uid: user.uid)
                                .updateFriendChatList(myChats.time, false);
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  userUid: user.uid,
                                  friendUserId: myChats.chatUid,
                                ),
                              ),
                            );
                          },
                          child: StreamBuilder<String>(
                              stream:
                                  DatabaseService(friendUid: myChats.chatUid)
                                      .userName,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  friendName = snapshot.data;
                                } else {
                                  friendName = 'Nobody';
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 5.0, bottom: 5.0, right: 20.0),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: myChats.unread
                                        ? Color(0xFFFFEFEE)
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 35.0,
                                            backgroundImage:
                                                NetworkImage(myChats.imageUrl),
                                          ),
                                          SizedBox(width: 10.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                friendName,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                child: Text(
                                                  myChats.text,
                                                  style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              myChats.time,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5.0),
                                            myChats.unread
                                                ? Container(
                                                    width: 40.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'NEW',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : Text(''),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          } else {
            return Loading();
          }
        });
  }
}
