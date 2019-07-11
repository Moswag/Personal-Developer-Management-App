import 'package:cytex/ui/screens/drawer.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:cytex/dev/footer/friend_detail_footer.dart';
import 'package:cytex/dev/friend_detail_body.dart';
import 'package:cytex/dev/header/friend_detail_header.dart';


class AboutDev extends StatefulWidget {

  @override
  _AboutDevPageState createState() => new _AboutDevPageState();
}

class _AboutDevPageState extends State<AboutDev> {
  @override
  Widget build(BuildContext context) {
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF413070),
          const Color(0xFF2B264A),
        ],
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: Text('About Developer'),
      ),
      drawer: DrawerOnly(),
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new FriendDetailBody(),
              ),
              new FriendShowcase(),
            ],
          ),
        ),
      ),
    );
  }
}
