import 'package:flutter/material.dart';
import 'package:cytex/ui/screens/home.dart';
import 'package:cytex/util/user_management.dart';



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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text('Webster Moswa'),
              accountEmail: Text('webstermoswa11@gmail.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
              ),
            ),
            new ListTile(
              title: new Text('Home Page'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (BuildContext context)=> new HomeScreen()));
              },
            ),
            new ListTile(
              title: new Text('Admin Page'),
              onTap: (){
                UserManagement().authoriseAccess(context);

              },
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: (){
                UserManagement().signOut();
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Text('Dashbord'),
      ),
    );
  }
}