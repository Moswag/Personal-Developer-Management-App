import 'package:flutter/material.dart';

import 'models/state.dart';
import 'ui/screens/dashbord.dart';
import 'ui/screens/project/view_projects.dart';
import 'ui/screens/sign_in.dart';
import 'util/state_widget.dart';
import 'util/auth.dart';


class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State createState() =>_RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{

  AuthStatus authStatus=AuthStatus.notSignedIn;
  StateModel appState;
  bool _loadingVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((userId){
      setState(() {
        authStatus=userId==null? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget
        .of(context)
        .state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.firstName ?? '';


      switch(authStatus) {
        case AuthStatus.notSignedIn:
          return new SignInScreen(
            auth: widget.auth,
            onSignedIn: _signedIn,
          );

        case AuthStatus.signedIn:
          if(name!=null){
            return ViewProjects();
          }

          else{
            return CircularProgressIndicator();
          }


      }

    }

  }
}