import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/config/app.dart';
import 'package:flutter_snap_chat/constant/app_color.dart';
import 'package:flutter_snap_chat/models/call_model.dart';
import 'package:flutter_snap_chat/repositories/call_repository.dart';

class CallScreen extends StatefulWidget {
  final CallModel call;

  CallScreen({
    @required this.call,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallRepository callMethods = CallRepository();

  FriendProviderCubit userProvider;
  StreamSubscription callStreamSubscription;
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (App.agoraId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, widget.call.channelId, null, 0);
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = BlocProvider.of<FriendProviderCubit>(context);

      callStreamSubscription = callMethods.callStream(uid: userProvider.state.userModel.id).listen((DocumentSnapshot ds) {
        // defining the logic
        switch (ds.data) {
          case null:
            // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }
      });
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(App.agoraId));
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {
          setState(() {
            final info = 'onError: $code';
            _infoStrings.add(info);
            print("------------------------------------");
            print("errorchanel: " + info);
          });
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          setState(() {
            print("------------------------------------");
            print("onJoinChannel:");
            final info = 'onJoinChannel: $channel, uid: $uid';
            _infoStrings.add(info);
          });
        },
        leaveChannel: (stats) {
          setState(() {
            _infoStrings.add('onLeaveChannel');
            _users.clear();
          });
        },
        userJoined: (uid, elapsed) {
          setState(() {
            print("------------------------------------");
            print("jion");
            final info = 'userJoined: $uid';
            _infoStrings.add(info);
            _users.add(uid);
          });
        },
        userOffline: (uid, elapsed) {
          setState(() {
            final info = 'userOffline: $uid';
            _infoStrings.add(info);
            _users.remove(uid);
          });
        },
        tokenPrivilegeWillExpire: (log) {
          print("--------------------------");
          print("destroy call:");
        },
        requestToken: () {},
        firstRemoteVideoFrame: (uid, width, height, elapsed) {
          setState(() {
            final info = 'firstRemoteVideo: $uid ${width}x $height';
            _infoStrings.add(info);
          });
        }));
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());

    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  _videoView(views[0]),
                ],
              ),
              Positioned(
                top: 100,
                left: MediaQuery.of(context).size.width / 2.9,
                child: Container(
                  child: Column(
                    children: [
                      Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 100.0,
                            height: 100.0,
                            // padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: widget.call.receiverPic,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.call.receiverName,
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          inherit: true,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Đang gọi điên...",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          inherit: true,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[_expandedVideoRow(views.sublist(0, 2)), _expandedVideoRow(views.sublist(2, 3))],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[_expandedVideoRow(views.sublist(0, 2)), _expandedVideoRow(views.sublist(2, 4))],
        ));
      default:
    }
    return Container();
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(call: widget.call, log: "accept").then((value) => Navigator.of(context).pop()),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
