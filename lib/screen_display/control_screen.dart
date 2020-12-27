import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_bloc.dart';
import 'package:flutter_snap_chat/blocs/count_request_friend_bloc/count_request_friend_state.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_state.dart';
import 'package:flutter_snap_chat/containers/containers.dart';
import 'package:flutter_snap_chat/containers/group_container.dart';
import 'package:flutter_snap_chat/widget/bottom_navigate.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {


  int _bottomSelectedIndex = 0;

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
      _bottomSelectedIndex = index;
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
                  child: Text(
                    state.count.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
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
                  child: Text(
                    state.count.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
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

    return Scaffold(
      body: BlocConsumer<UserProviderCubit, UserProviderState>(
          builder: (context, state) {
            return state.status == UserProviderStatus.success
                ? buildPageView()
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
          listener: (context,state){
            if(state.status == UserProviderStatus.success){
              FirebaseAuth.instance
                  .authStateChanges()
                  .listen((User user) {
                if (user == null) {
                  print('User is currently signed out!');
                } else {
                  FirebaseFirestore.instance.collection('users')
                      .doc(user.uid).update({
                    'status':"0",
                  });
                }
              });
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomSelectedIndex,
        backgroundColor: Colors.white,
        onTap: (index) => bottomTapped(index),
        items: items,
      ),
    );
  }
}
