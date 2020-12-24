

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/containers/add_search_name_chat_container.dart';
import 'package:flutter_snap_chat/containers/control_container.dart';
import 'package:flutter_snap_chat/containers/group_container.dart';
import 'package:flutter_snap_chat/containers/init_container.dart';
import 'package:flutter_snap_chat/containers/login_container.dart';
import 'package:flutter_snap_chat/home.dart';
import 'package:flutter_snap_chat/screen_display/sign_up_page.dart';
import 'containers/containers.dart';
import 'file:///E:/btl%20di%20dong/btl_didong/flutter_snap_chat/lib/screen_display/login.dart';
import 'package:flutter_snap_chat/screen_display/add_group_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/room_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/contact_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/friend_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/menu_screen.dart';
import 'package:flutter_snap_chat/settings.dart';

class AppRoutes {
  static const home = "/home";
  static const login = "/login";
  static const settings = "/settings";
  static const more = "/more";
  static const init = "/init";
  static const control = "/control";
  static const menu = "menu";
  static const chatDisplay = "/chat_display";
  static const friendDisplay = "/friend_display";
  static const contactDisplay = "/contact_display";
  static const groupDisplay = "/group";
  static const addGroupDisplay = "/group_display";
  static const space = "/space";
  static const addSearchNameChat = "/add_search_name_chat";
  static const signup ="/signup";

  static dynamic getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return CupertinoPageRoute(builder:(_)=>HomeScreen(), settings: settings);
      case AppRoutes.login:
        return CupertinoPageRoute(builder:(_)=>LoginContainer(), settings: settings);
      case AppRoutes.chatDisplay:
        return CupertinoPageRoute(builder:(_)=>RoomContainer(), settings: settings);
      case AppRoutes.friendDisplay:
        return CupertinoPageRoute(builder:(_)=>FriendContainer(), settings: settings);
      case AppRoutes.contactDisplay:
        return CupertinoPageRoute(builder:(_)=>ContactContainer(), settings: settings);
      case AppRoutes.addGroupDisplay:
        return CupertinoPageRoute(builder:(_)=>AddGroupDisplayScreen(), settings: settings);
      case AppRoutes.settings:
        return CupertinoPageRoute(builder:(_)=>ChatSettings(), settings: settings);
      case AppRoutes.control:
        return CupertinoPageRoute(builder:(_)=>ControlContainer(), settings: settings);
      case AppRoutes.space:
        return CupertinoPageRoute(builder:(_)=>LoginScreen(), settings: settings);
      case AppRoutes.init:
        return CupertinoPageRoute(builder:(_)=>InitContainer(), settings: settings);
      case AppRoutes.menu:
        return CupertinoPageRoute(builder:(_)=>MenuScreen(), settings: settings);
      case AppRoutes.groupDisplay:
        return CupertinoPageRoute(builder:(_)=>GroupContainer(), settings: settings);
      case AppRoutes.addSearchNameChat:
        return CupertinoPageRoute(builder:(_)=>AddSearchNameChatContainer(), settings: settings);
      case AppRoutes.signup:
        return CupertinoPageRoute(builder: (_)=>SignUpPage(),settings: settings);
      default:
        return CupertinoPageRoute(builder:(_)=>InitContainer(), settings: settings);
    }
  }

  // ignore: non_constant_identifier_names
  static NavPush(BuildContext context, String route) {

  }

  // ignore: non_constant_identifier_names
  static NavReplace(BuildContext context, String route) {

  }
}

