import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/models/user_model.dart';
class NavObject {
  String route;
  Icon navIcon;
  String title;

  NavObject({this.route, this.navIcon, this.title});
}

class BottomNavigate extends StatefulWidget {
  @override
  _BottomNavigateState createState() => _BottomNavigateState();
}

class _BottomNavigateState extends State<BottomNavigate> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String uid = context.select((AuthenticationBloc bloc) => bloc.state.user.id);

    List<NavObject> navs = [
      NavObject(
        route: "/chat_display",
        navIcon: Icon(Icons.chat),
        title: 'Chat',
      ),
      NavObject(
        route: "/friend_display",
        navIcon: Icon(Icons.perm_contact_cal),
        title: 'Bạn bè',
      ),
      NavObject(
        route: "/group",
        navIcon: Icon(Icons.people),
        title: 'Group',
      ),
      NavObject(
        route: "/contact_display",
        navIcon: Icon(Icons.person_add_alt_1),
        title: 'Kết nối',
      ),
    ];
    List<BottomNavigationBarItem> items = [];
    var curIndex = navs.indexWhere((element) {
      return ModalRoute.of(context).settings.name == element.route;
    });
    _selectedIndex = navs.asMap().containsKey(curIndex) ? curIndex : 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;

        Navigator.of(context).popAndPushNamed(navs[index].route, arguments: {
          "userId":  uid,

        });
      });
    }

    navs.asMap().forEach((index, element) {
      items.add(BottomNavigationBarItem(
        icon: element.navIcon,
        label: element.title,
      ));
    });
    return BottomNavigationBar(
      items: items,
      currentIndex: _selectedIndex,
//      iconSize: Responsive().setImageSize(3),
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }
}
