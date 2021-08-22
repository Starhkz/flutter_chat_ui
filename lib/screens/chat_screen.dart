import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/message_model.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/services/database.dart';
import 'package:flutter_chat_ui/shared/loading.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String userUid;
  final User friendUser;
  final String friendUserId;

  ChatScreen({this.userUid, this.friendUser, this.friendUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textHolder = TextEditingController();
  String text;
  String friendId;
  String friendName;
  @override
  Widget build(BuildContext context) {
    if (widget.friendUser != null) {
      friendId = widget.friendUser.uid;
    } else {
      friendId = widget.friendUserId;
    }
    return StreamBuilder<List<Message>>(
        stream: DatabaseService(uid: widget.userUid, friendUid: friendId)
            .friendMessage,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messageTile = snapshot.data;
            return StreamBuilder<String>(
                stream: DatabaseService(friendUid: friendId).userName,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    friendName = snapshot.data;
                  } else {
                    friendName = 'Nobody';
                  }
                  return Scaffold(
                    backgroundColor: Theme.of(context).primaryColor,
                    appBar: AppBar(
                      title: Text(
                        friendName,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      elevation: 0.0,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          iconSize: 30.0,
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Column(
                        children: <Widget>[
                          Expanded(
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
                                  reverse: false,
                                  padding: EdgeInsets.only(top: 15.0),
                                  itemCount: messageTile.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Message message = messageTile[index];
                                    final bool isMe =
                                        message.send == widget.userUid;
                                    return _buildMessage(message, isMe);
                                  },
                                ),
                              ),
                            ),
                          ),
                          _buildMessageComposer(
                              widget.userUid, widget.friendUser),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Loading();
          }
        });
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () {
            DatabaseService(uid: widget.userUid, friendUid: friendId)
                .updateMessage(message.time, !message.isLiked, false);
            DatabaseService(uid: widget.userUid, friendUid: friendId)
                .updateFriendMessage(message.time, !message.isLiked, false);
          },
        )
      ],
    );
  }

  _buildMessageComposer(String user, User friendUser) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              autocorrect: true,
              controller: textHolder,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              textHolder.clear();
              FocusScope.of(context).unfocus();
              await DatabaseService(uid: user, friendUid: friendId)
                  .uploadMessage(
                      null, null, DateTime.now().toString(), text, true, false);
              await DatabaseService(uid: user, friendUid: friendId)
                  .uploadFriendMessage(
                      null, null, DateTime.now().toString(), text, true, false);
              await DatabaseService(uid: user, friendUid: friendId)
                  .uploadChatList(DateTime.now().toString(), true, text, null);
              await DatabaseService(uid: user, friendUid: friendId)
                  .uploadFriendChatList(
                      DateTime.now().toString(), true, text, null);
            },
          ),
        ],
      ),
    );
  }
}
