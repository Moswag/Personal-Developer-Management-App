import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/cytex_routes.dart';
import 'package:cytex/models/idea.dart';
import 'package:cytex/models/learnt.dart';
import 'package:cytex/models/question.dart';
import 'package:cytex/models/spending.dart';
import 'package:cytex/models/state.dart';
import 'package:cytex/models/technology.dart';
import 'package:cytex/service/cytex_service.dart';
import 'package:cytex/ui/screens/sign_in.dart';
import 'package:cytex/ui/widgets/loading.dart';
import 'package:cytex/util/alert_dialog.dart';
import 'package:cytex/util/state_widget.dart';
import 'package:cytex/util/validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';




class AddSpending extends StatefulWidget {
  AddSpending({this.email});
  final String email;

  @override
  State createState() => _AddSpendingState();
}

class _AddSpendingState extends State<AddSpending> {
  StateModel appState;
  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _categoryVisibility = true;
  String startDate, endDate;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController reasonController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();


  Future _addSpending({Spending spending,String amount}) async {
    //verifying userType is Direct or Franchise to determine category

    spending.date=DateTime.now().year.toString()+'/'+DateTime.now().month.toString()+'/'+DateTime.now().day.toString();
    spending.time=DateTime.now().hour.toString()+'/'+DateTime.now().minute.toString()+'/'+DateTime.now().second.toString();

    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        var id = utf8.encode(spending.reason +
            DateTime.now().millisecondsSinceEpoch.toString()); // data being hashed


        spending.id = sha1.convert(id).toString();
        spending.amount=double.parse(amount);



        MyService.addSpending(spending).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(context, 'Status',
                'Spending Successfully Recorded', MyRoutes.VIEW_SPENDINGS);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add Spending, please contact developer',
                MyRoutes.VIEW_PROJECTS);
          }
        });

      } catch (e) {
        print("Adding Spending: $e");
        Flushbar(
            title: "Adding Spending Error",
            message: e,
            duration: Duration(seconds: 5))
            .show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null ||
            appState.user == null ||
            appState.settings == null)) {
      return SignInScreen();
    } else {
      final userId = appState?.firebaseUserAuth?.uid ?? '';

      //define form fields



      final header = Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(CytexConstants.BACKGROUND_IMAGE),
              fit: BoxFit.cover),
          color: Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Spend',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Add Spending',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Icon(
              Icons.book,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      );



      final reasonField = Visibility(
        visible: _categoryVisibility,
        child: TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: reasonController,
            validator: Validator.validateField,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.note_add,
                  color: Colors.black,
                ), // icon is 48px widget.
              ), // icon is 48px widget.
              hintText: 'Reason',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            )),
      );

      final amountField = Visibility(
        visible: _categoryVisibility,
        child: TextFormField(
            autofocus: false,
            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
            controller: amountController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter amount';
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.black,
                ), // icon is 48px widget.
              ), // icon is 48px widget.
              hintText: 'Amount',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            )),
      );



      final submitButton = Expanded(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              'Save',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                debugPrint("Save clicked");
                Spending spend=new Spending();
                spend.userId = userId;
                spend.reason=reasonController.text;
                String amnt=amountController.text;

                _addSpending(spending: spend, amount:amnt);
              });
            }),
      );

      final cancelButton = Expanded(
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              'Cancel',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                debugPrint("Cancel button clicked");
                Navigator.pop(context);
              });
            }),
      );

      Form form = Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    header,
                    SizedBox(height: 20.0),
                    reasonField,
                    SizedBox(height: 24.0),
                    amountField,
                    SizedBox(height: 24.0),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          submitButton,
                          Container(
                            width: 5.0,
                          ), //for adding space between buttons
                          cancelButton
                        ],
                      ),
                    ),
                  ],
                ),
              )));

      return WillPopScope(
          onWillPop: () {
            moveToLastScreen();
          },
          child: Scaffold(
              appBar: new AppBar(
                elevation: 0.1,
                backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                title: Text('Spending'),
              ),
              body: LoadingScreen(
                child: form,
                inAsyncCall: _loadingVisible,
              )));
    }
  }





  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
