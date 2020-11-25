
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';

class AddGroupItem extends StatefulWidget {
  final List<DocumentSnapshot> lstDocuments;
  final String id;

  const AddGroupItem({Key key,@required this.lstDocuments,@required this.id}) : super(key: key);
  @override
  _AddGroupItemState createState() => _AddGroupItemState();
}

class _AddGroupItemState extends State<AddGroupItem> {
  List<String> idFriend = [];
  List<String> idRequest = [];
  List<bool> lstSelect = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData() {
    widget.lstDocuments.forEach((element) {
      List<String> strings = element.id.split("-");
      if (strings[0] == widget.id || strings[1] == widget.id) {
        print(element.data()[widget.id]);
        print(element.data()[widget.id]);
        if (element.data()[widget.id] == 'accept_request') {
          if (strings[0] == widget.id) {
            idRequest.add(strings[1]);
          } else {
            idRequest.add(strings[0]);
          }
        } else if(element.data()[widget.id] == 'success'){
          if (strings[0] == widget.id) {
            idFriend.add(strings[1]);
            lstSelect.add(false);
          } else {
            idFriend.add(strings[0]);
            lstSelect.add(false);
          }
          print(idFriend.length);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,10,20,30),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                hintText: "Tìm kiếm",
                prefixIcon: Icon(Icons.search)
            ),
          ),
          Container(
            child: Column(
              children: [
                Text("Bạn bè"),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: idFriend.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: FirebaseFirestore.instance.collection("users").doc(idFriend[index]).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              return itemFriend(snapshot.data,index);
                            }
                            return Text("loading");
                          });
                    }),
              ],
            ),),
        ],
      ),
    );
  }
  Widget itemFriend(DocumentSnapshot document,int index) {
    return InkWell(
      child: Container(
        child: Row(
          children: <Widget>[
            Material(
              child: document.data()['photoUrl'] != null
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
                imageUrl: document.data()['photoUrl'],
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
            Container(
              child: Container(
                child: Text(
                  '${document.data()['nickname']}',
                  style: TextStyle(color: primaryColor),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
              ),
              margin: EdgeInsets.only(left: 20.0),
            ),
           !lstSelect[index] ? Icon(Icons.add_circle_outline): Icon(Icons.add_circle),
          ],
        ),
      ),
      onTap: (){
        setState(() {
          lstSelect[index] = !lstSelect[index];
        });
      },
    );
  }
}

