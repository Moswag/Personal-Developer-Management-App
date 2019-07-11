import 'package:flutter/material.dart';

class SkillsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Column(
      children: <Widget>[
        Text(
            'Java: Spring, EJB, JavaFX, Android Dev',
            style: textTheme.title.copyWith(color: Colors.white),
          ),


         Text(
            'Php: Laravel, OOP',
            style: textTheme.title.copyWith(color: Colors.white),
          ),

        Text(
          'Python: Django',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'Dart: Flutter, Web Development',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'C++: Game Developemt using Unreal Engine',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'Javascript: Angular',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'MQ: IBM Message Quiuing',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'IIB: IBM Intergration Bus',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'So much more',
          style: textTheme.title.copyWith(color: Colors.white),
        ),
        Text(
          'Contact : 263 771 407 147',
          style: textTheme.title.copyWith(color: Colors.white),
        ),








      ],

    );
  }
}
