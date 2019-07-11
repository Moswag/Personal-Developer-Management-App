import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/cytex_routes.dart';
import 'package:cytex/constants/db_constants.dart';
import 'package:cytex/models/business.dart';
import 'package:cytex/models/payment.dart';
import 'package:cytex/models/project.dart';
import 'package:cytex/models/state.dart';
import 'package:cytex/service/cytex_service.dart';
import 'package:cytex/ui/screens/sign_in.dart';
import 'package:cytex/ui/widgets/loading.dart';
import 'package:cytex/util/alert_dialog.dart';
import 'package:cytex/util/state_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:path/path.dart' as Path;
import 'package:mime/mime.dart';

class AddPayment extends StatefulWidget {
  AddPayment({this.email});
  final String email;

  @override
  State createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  StateModel appState;
  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _categoryVisibility = true;
  String startDate, endDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountController = new TextEditingController();

  String nature = '';
  String client;
  static var _nature = CytexConstants.BUSINESS_NATURE;

  Future _addPayment({Payment payment, String amount}) async {
    //verifying userType is Direct or Franchise to determine category
    payment.date = DateTime.now().year.toString() +
        '/' +
        DateTime.now().month.toString() +
        '/' +
        DateTime.now().day.toString();

    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        var id = utf8.encode(payment.client +
            payment.date +
            payment.amount.toString() +
            DateTime.now()
                .millisecondsSinceEpoch
                .toString()); // data being hashed

        payment.id = sha1.convert(id).toString();
        payment.amount=double.parse(amount);

        MyService.addPayment(payment).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(context, 'Status',
                'Payment Successfully Recorded', MyRoutes.VIEW_PAYMENTS);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to add Payment, please contact developer',
                MyRoutes.VIEW_PROJECTS);
          }
        });
      } catch (e) {
        print("Adding Error: $e");
        Flushbar(
                title: "Adding Payment Error",
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
    nature = _nature[0];
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
              'Payment',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Add Payment',
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

      final natureField = Container(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                  child: Text(
                    "Business Nature",
                  ),
                )),
            new Expanded(
              flex: 4,
              child: DropdownButton(
                  items: _nature.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  iconSize: 20,
                  value: nature,
                  onChanged: (valueSelectedByUser) {
                    _onProjectNatureItemSelected(valueSelectedByUser);
                  }),
            )
          ]));

      final clientField = StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(DBConstants.TABLE_BUSINESS)
              .where('nature', isEqualTo: nature)
              .where('status', isEqualTo: CytexConstants.BUSINESS_OWING)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CupertinoActivityIndicator(),
              );

            return Container(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                        child: Text(
                          "Client",
                        ),
                      )),
                  new Expanded(
                    flex: 4,
                    child: DropdownButton(
                      value: client,
                      isDense: true,
                      onChanged: (valueSelectedByUser) {
                        _onClientItemSelected(valueSelectedByUser);
                      },
                      hint: Text('Choose client'),
                      items: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document.data['client'],
                          child: Text(document.data['client']
                          )
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          });

      final amountField = Visibility(
          visible: _categoryVisibility,
          child: TextFormField(
            autofocus: false,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
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
            ),
          ));

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
                Payment pay = new Payment();
                pay.userId = userId;
                pay.nature = nature;
                pay.client = client;
                String amnt = amountController.text;

                _addPayment(payment: pay, amount: amnt);
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
                    natureField,
                    SizedBox(height: 10.0),
                    clientField,
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
                title: Text('Add Payment'),
              ),
              body: LoadingScreen(
                child: form,
                inAsyncCall: _loadingVisible,
              )));
    }
  }

  void _onProjectNatureItemSelected(String newValueSelected) {
    setState(() {
      this.nature = newValueSelected;
      if (newValueSelected == CytexConstants.NATURE_PERSONAL) {
        this._categoryVisibility = false;
      } else {
        this._categoryVisibility = true;
      }
    });
  }

  void _onClientItemSelected(String newValueSelected) {
    setState(() {
      this.client = newValueSelected;
    });
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
