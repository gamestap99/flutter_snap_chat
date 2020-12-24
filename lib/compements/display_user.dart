import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class DisplayUser extends StatefulWidget {
  final UserModel userModel;

  const DisplayUser({Key key, @required this.userModel}) : super(key: key);

  @override
  _DisplayUserState createState() => _DisplayUserState();
}

class _DisplayUserState extends State<DisplayUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: widget.userModel.photo != null
                ? CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                    imageUrl: widget.userModel.photo,
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.account_circle,
                    size: 50.0,
                    color: greyColor,
                  ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          ),
          Flexible(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      '${widget.userModel.name}',
                      style: TextStyle(color: primaryColor),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
