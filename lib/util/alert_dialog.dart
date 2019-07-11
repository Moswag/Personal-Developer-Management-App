

import 'package:flutter/material.dart';

class AlertDiag{
  static void showAlertDialog(BuildContext context, String title, String messge, String route) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(messge),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Theme
              .of(context)
              .primaryColorDark,
          textColor: Theme
              .of(context)
              .primaryColorLight,
          child: Text(
            'Ok',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            Navigator.pushNamed(context, route);

          },
        ),
      ],

    );

    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}