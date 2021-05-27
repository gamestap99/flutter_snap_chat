import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/models/call_model.dart';
import 'package:flutter_snap_chat/repositories/call_repository.dart';
import 'package:flutter_snap_chat/screen_display/callscreens/call_screen.dart';
import 'package:flutter_snap_chat/utils/permissions.dart';
import 'package:flutter_snap_chat/widget/cached_image_widget.dart';

class PickupScreen extends StatefulWidget {
  final CallModel call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallRepository callMethods = CallRepository();

  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;

  // addToLocalStorage({@required String callStatus}) {
  //   Log log = Log(
  //     callerName: widget.call.callerName,
  //     callerPic: widget.call.callerPic,
  //     receiverName: widget.call.receiverName,
  //     receiverPic: widget.call.receiverPic,
  //     timestamp: DateTime.now().toString(),
  //     callStatus: callStatus,
  //   );
  //
  //   LogRepository.addLogs(log);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AssetsAudioPlayer().open(Audio("assets/audios/call.mp3"), autoStart: true);
  }

  @override
  void dispose() {
    // if (isCallMissed) {
    //   addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            CachedImageWidget(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    // addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call, log: "reject");
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      // addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
