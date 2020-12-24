import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_state.dart';
import 'package:flutter_snap_chat/containers/containers.dart';
import 'package:flutter_snap_chat/containers/group_container.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: PageScrollPhysics(parent: NeverScrollableScrollPhysics()),
      children: [
        RoomContainer(),
        FriendContainer(),
        GroupContainer(),
        ContactContainer(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        activeIcon: Icon(Icons.chat),
        icon: Icon(Icons.chat_outlined),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Stack(
          children: [
            Icon(Icons.perm_contact_calendar_outlined),
            BlocBuilder<CountRequestFriendBloc, CountRequestFriendState>(builder: (context, state) {
              return Visibility(
                visible: state.count == 0 ? false : true,
                child: Positioned(
                  top: -3,
                  left: 15,
                  child: Text(state.count.toString(),style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),),
                ),
              );
            }),
          ],
        ),
        activeIcon: Stack(
          children: [
            Icon(Icons.perm_contact_cal),
            BlocBuilder<CountRequestFriendBloc, CountRequestFriendState>(builder: (context, state) {
              return Visibility(
                visible: state.count == 0 ? false : true,
                child: Positioned(
                  top: -3,
                  left: 15,
                  child: Text(state.count.toString(),style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),),
                ),
              );
            }),
          ],
        ),
        label: 'Bạn bè',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Group',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_add_alt_1),
        label: 'Kết nối',
      ),
    ];
    // navs.asMap().forEach((index, element) {
    //   items.add(BottomNavigationBarItem(
    //     icon: Stack(
    //       children: [
    //         element.navIcon,
    //         BlocBuilder<CountRequestFriendBloc, CountRequestFriendState>(builder: (context, state) {
    //           return Visibility(
    //             visible: state.count == 0 ? true : true,
    //             child: Positioned(
    //               top: -3,
    //               left: 15,
    //               child: Text(state.count.toString()),
    //             ),
    //           );
    //         }),
    //       ],
    //     ),
    //     label: element.title,
    //   ));
    // });
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomSelectedIndex,
        backgroundColor: Colors.white,
        onTap: (index) => bottomTapped(index),
        items: items,
      ),
    );
  }
}
