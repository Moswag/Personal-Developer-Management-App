import 'package:flutter/material.dart';
import 'package:cytex/ui/screens/home.dart';
import 'package:cytex/util/user_management.dart';

import 'drawer.dart';



class DashBoardPage extends StatefulWidget{

  @override
  State createState() =>_DashBoardPageState();
}


class _DashBoardPageState extends State<DashBoardPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      drawer: DrawerOnly(),
      body: Center(
        child: Text('Dashbord'),
      ),
    );
  }
}