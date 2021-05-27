import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/containers/profile_container.dart';
import 'package:flutter_snap_chat/models/user_model.dart';

class ContactItem extends StatelessWidget {
  final UserModel userModel;
  final String uid;
  final int index;

  const ContactItem({Key key, @required this.userModel, @required this.uid, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return ProfileContainer(
              uid: uid,
              peerUser: userModel,
              index: index,
            );
          }),
        );
      },
      child: Hero(
        tag: "infoUser $index",
        child: Card(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: userModel.background != null
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
                        imageUrl: userModel.background,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: greyColor.withOpacity(0.2),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Material(
                      child: userModel.avatar != null
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
                              imageUrl: userModel.avatar,
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
                                userModel.name != null ? userModel.name : "dd",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
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
                margin: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
