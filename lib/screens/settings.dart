import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/models/user_model.dart';
import 'package:flutter_chat_ui/services/database.dart';

import 'package:flutter_chat_ui/shared/constant.dart';
import 'package:flutter_chat_ui/shared/loading.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// For Image Picker
import 'package:path/path.dart' as Path;

class Settings extends StatefulWidget {
  final String userUid;
  Settings({this.userUid});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // TaskSnapshot taskSnapshot;

  File _image;
  String url;
  String name;
  String _currentName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: DatabaseService(uid: widget.userUid).myData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            name = user.name;
            return Scaffold(
              appBar: AppBar(
                title: Text(user.name),
              ),
              backgroundColor: Colors.blue[100],
              body: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: user.name,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Name'),
                      validator: (value) =>
                          value.isEmpty ? 'Please enter your name' : null,
                      onChanged: (value) {
                        setState(() {
                          _currentName = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        setState(() {
                          print(user.name);
                          print(_currentName);
                          print(user.uid);
                        });
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context);
                          await DatabaseService(uid: user.uid).updateUser(
                              null, _currentName ?? user.name, user.imageUrl);
                        }
                      },
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Selected Image'),
                    _image != null
                        ? Image.asset(
                            _image.path,
                            height: 150,
                          )
                        : Container(height: 150),
                    _image == null
                        ? RaisedButton(
                            child: Text('Choose File'),
                            onPressed: pickImage,
                            color: Colors.cyan,
                          )
                        : Container(),
                    _image != null
                        ? RaisedButton(
                            child: Text('Upload File'),
                            onPressed: () async {
                              uploadImageToFirebase();
                            },
                            color: Colors.cyan,
                          )
                        : Container(),
                    _image != null
                        ? RaisedButton(
                            child: Text('Clear Selection'),
                            onPressed: null,
                          )
                        : Container(),
                    Text('Uploaded Image'),
                    url != null
                        ? Image.network(
                            url,
                            height: 150,
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }

//   Future chooseFile() async {
//    await _picker.getImage(source: ImageSource.gallery).then((image) {
//      setState(() {
//        _image = image;
//      });
//    });
//  }
  Future pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(widget.userUid);
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          url = fileURL;
          print(url);
        });
        print('Stuff');
        DatabaseService(uid: widget.userUid).updateUser(null, name, url);
      });
    });
  }
  // await uploadTask.whenComplete(() {
  //   TaskSnapshot taskSnapshot;
  //   return taskSnapshot.ref.getDownloadURL().then(
  //     (value) {
  //       url = value;
  //       print("Done: $value");
  //       print('$url');
  //     },
  //   );
  // });

}
