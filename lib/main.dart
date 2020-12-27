import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snap_chat/blocs/authentication_bloc/bloc.dart';
import 'package:flutter_snap_chat/blocs/process_contact_bloc/process_contact_bloc.dart';
import 'package:flutter_snap_chat/blocs/user_provider_bloc/user_provider_cubit.dart';
import 'package:flutter_snap_chat/database/user.g.dart';
import 'package:flutter_snap_chat/repositories/contact_repository.dart';
import 'package:flutter_snap_chat/repositories/friend_repository.dart';
import 'package:flutter_snap_chat/repositories/user_repository.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/simple_bloc_observer.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:firebase_auth/firebase_auth.dart';

import 'const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserAdapter());
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const MyApp({Key key, @required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authenticationRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: authenticationRepository),
            ),
            BlocProvider(
              create: (_) => ProcessContactBloc(ApiContactRepository()),
            ),
            BlocProvider(
              create: (_) => UserProviderCubit(ApiFriendRepository()),
            )
          ],
          child: MyAppView(),
        ));
  }
}

class MyAppView extends StatefulWidget {
  @override
  _MyAppViewState createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(context.read<AuthenticationBloc>().state.user.id.length > 0){
    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestore.instance
            .collection('users')
            .doc(context.read<AuthenticationBloc>().state.user.id)
            .update({
          'status': "0",
        });
        // FirebaseAuth.instance.authStateChanges().listen((User user) {
        //   if (user == null) {
        //     print('User is currently signed out!');
        //   } else {
        //     FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(user.uid)
        //         .update({
        //       'status': "0",
        //     });
        //   }
        // });
        break;
      case AppLifecycleState.inactive:
          FirebaseFirestore.instance
              .collection('users')
              .doc(context.read<AuthenticationBloc>().state.user.id)
              .update({
            'status': "1",
          });
        // FirebaseAuth.instance.authStateChanges().listen((User user) {
        //   if (user == null) {
        //     print('User is currently signed out!');
        //   } else {
        //     FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(user.uid)
        //         .update({
        //       'status': "1",
        //     });
        //   }
        // });
        break;
      case AppLifecycleState.paused:
        FirebaseFirestore.instance
            .collection('users')
            .doc(context.read<AuthenticationBloc>().state.user.id)
            .update({
          'status': "1",
        });
        // FirebaseAuth.instance.authStateChanges().listen((User user) {
        //   if (user == null) {
        //     print('User is currently signed out!');
        //   } else {
        //     FirebaseFirestore.instance
        //         .collection('users')
        //         .doc(user.uid)
        //         .update({
        //       'status': "1",
        //     });
        //   }
        // });
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) =>
          AppRoutes.getRoutes(settings),
      initialRoute: AppRoutes.init,
    );
  }
}
