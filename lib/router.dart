

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/home.dart';
import 'package:flutter_snap_chat/login.dart';
import 'package:flutter_snap_chat/screen_display/add_group_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/chat_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/contact_display_screen.dart';
import 'package:flutter_snap_chat/screen_display/friend_display_screen.dart';
import 'package:flutter_snap_chat/settings.dart';

class AppRoutes {
  static const home = "/home";
  static const login = "/login";
  static const settings = "/settings";
  static const more = "/more";
  static const chatDisplay = "/chat_display";
  static const friendDisplay = "/friend_display";
  static const contactDisplay = "/contact_display";
  static const addGroupDisplay = "/group_display";
  static const space = "/space";
  static const timelapseProject = "/timelapse_project";
  static const timelapseProjectInfo = "/timelapse_project_info";

  static dynamic getRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return CupertinoPageRoute(builder:(_)=>HomeScreen(), settings: settings);
      case AppRoutes.login:
        return CupertinoPageRoute(builder:(_)=>LoginScreen(), settings: settings);
      case AppRoutes.chatDisplay:
        return CupertinoPageRoute(builder:(_)=>ChatDisplayScreen(), settings: settings);
      case AppRoutes.friendDisplay:
        return CupertinoPageRoute(builder:(_)=>FriendDisplayScreen(), settings: settings);
      case AppRoutes.contactDisplay:
        return CupertinoPageRoute(builder:(_)=>ContactDisplayScreen(), settings: settings);
      case AppRoutes.addGroupDisplay:
        return CupertinoPageRoute(builder:(_)=>AddGroupDisplayScreen(), settings: settings);
      case AppRoutes.settings:
        return CupertinoPageRoute(builder:(_)=>ChatSettings(), settings: settings);
      case AppRoutes.space:
        return CupertinoPageRoute(builder:(_)=>LoginScreen(), settings: settings);
      default:
        return CupertinoPageRoute(builder:(_)=>LoginScreen(), settings: settings);
    }
  }

  // ignore: non_constant_identifier_names
  static NavPush(BuildContext context, String route) {

  }

  // ignore: non_constant_identifier_names
  static NavReplace(BuildContext context, String route) {

  }
}

