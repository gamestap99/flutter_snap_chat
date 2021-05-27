import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/bot_bloc/bot_cubit.dart';
import 'package:flutter_snap_chat/blocs/bot_bloc/bot_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/models/robot_model.dart';
import 'package:flutter_snap_chat/widget/loading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({Key key}) : super(key: key);

  @override
  _BotScreenState createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  String _uid;
  String userName;
  List<dynamic> listMessage = new List.from([]);
  String groupChatId;
  String roomID;
  bool isLoading = false;
  bool isShowSticker;
  String imageUrl;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  BotCubit _botCubit;

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
      });
    }
    if (listScrollController.offset <= listScrollController.position.minScrollExtent && !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    _botCubit = BlocProvider.of<BotCubit>(context);
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void onSendMessage(String content, int type, String sender) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      // setState(() {
      //
      //   listMessage.insert(0,content);
      // });
      _botCubit.onSendMessage(content, sender);
    } else {}
  }

  Widget buildItem(int index, var data, List<dynamic> list) {
    if (data is String) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              data,
              style: TextStyle(color: primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index, list) ? 20.0 : 10.0, right: 10.0),
          ),
          // Sticker,
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else if (data is RobotModel) {
      // Left (peer message)

      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: FaIcon(FontAwesomeIcons.robot),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                Container(
                  child: Text(
                    data.text,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }

    return SizedBox.shrink();
  }

  bool isLastMessageLeft(int index, List<dynamic> list) {
    if ((index > 0 && listMessage != null && list[index - 1] is String) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index, List<dynamic> list) {
    if ((index > 0 && listMessage != null && list[index - 1] is Map) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    var _sender = context.select((FriendProviderCubit bloc) => bloc.state.userModel.name.toString());
    // userName = context.select((FriendProviderCubit cubit) => cubit.state.userModel.name.toString());

    return WillPopScope(
      child: Scaffold(
        body: BlocConsumer<BotCubit, BotState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //appbar
                      appBar(),
                      // List of messages
                      buildListMessage(),

                      // Input content
                      buildInput(_sender),
                    ],
                  ),

                  // Loading
                  buildLoading()
                ],
              );
            },
            listener: (context, state) {}),
      ),
      onWillPop: onBackPress,
    );
  }

  Widget appBar() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 5,
            ),
            Material(
              child: FaIcon(FontAwesomeIcons.robot),
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                "ND Bot",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput(String sender) {
    return BlocBuilder<BotCubit, BotState>(builder: (context, state) {
      return state.botRender != BotRender.loading
          ? Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: TextField(
                        onSubmitted: (value) {
                          onSendMessage(textEditingController.text, 0, sender);
                        },
                        style: TextStyle(color: primaryColor, fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Nhập tin nhắn...',
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        focusNode: focusNode,
                      ),
                    ),
                  ),

                  // Button send message
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => onSendMessage(textEditingController.text, 0, sender),
                        color: primaryColor,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(border: Border(top: BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
            )
          : Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SpinKitThreeBounce(color: Colors.red),
                ],
              ),
            );
    });
  }

  Widget buildListMessage() {
    return BlocBuilder<BotCubit, BotState>(builder: (context, state) {
      return Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return buildItem(index, state.listMessage[index], state.listMessage);
          },
          itemCount: state.listMessage.length,
          reverse: true,
          controller: listScrollController,
        ),
      );
    });
  }
}
