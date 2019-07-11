import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/cytex_routes.dart';
import 'package:cytex/models/idea.dart';
import 'package:cytex/models/learnt.dart';
import 'package:cytex/models/question.dart';
import 'package:cytex/models/state.dart';
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




class EditQuestion extends StatefulWidget {
  EditQuestion({this.question,this.index});
  final Question question;
  final index;

  @override
  State createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  StateModel appState;
  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _answerVisibility = false;
  String startDate, endDate;


  String status = '';
  static var _status = CytexConstants.QUESTION_STATUS;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController shortAnswerController = new TextEditingController();
  TextEditingController questionController = new TextEditingController();


  Future _updateQuestion({Question question}) async {
    //verifying userType is Direct or Franchise to determine category

    question.date=DateTime.now().year.toString()+'/'+DateTime.now().month.toString()+'/'+DateTime.now().day.toString();

    if (_formKey.currentState.validate()) {
      try {

        print("in try of update method");
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        var id = utf8.encode(question.question +
            DateTime.now().millisecondsSinceEpoch.toString()); // data being hashed


        question.id = sha1.convert(id).toString();


        MyService.updateQuestion(question,widget.index).then((onValue) {
          if (onValue) {
            AlertDiag.showAlertDialog(context, 'Status',
                'Question Successfully Updated', MyRoutes.VIEW_QUESTIONS);
          } else {
            AlertDiag.showAlertDialog(
                context,
                'Status',
                'Failed to update Question, please contact developer',
                MyRoutes.VIEW_PROJECTS);
          }
        });

      } catch (e) {
        print("Adding Question: $e");
        Flushbar(
            title: "Adding Question Error",
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
    status = _status[0];
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
              'Question',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Edit Question',
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



      final questionField =  TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: questionController,
            enabled: false,
            //initialValue: widget.question.question,
            //validator: Validator.validateField,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.format_quote,
                  color: Colors.black,
                ), // icon is 48px widget.
              ), // icon is 48px widget.
              hintText: widget.question.question,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
      );

      final statusField = Container(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                  child: Text(
                    "Question Status",
                  ),
                )),
            new Expanded(
              flex: 4,
              child: DropdownButton(
                  items: _status.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  iconSize: 20,
                  value: status,
                  onChanged: (valueSelectedByUser) {
                    _onQuestionStatusItemSelected(valueSelectedByUser);
                  }),
            )
          ]));

      final shortAnswerField =Visibility(
          visible: _answerVisibility,
          child:TextFormField(
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.text,
            controller: shortAnswerController,
            validator: Validator.validateField,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.question_answer,
                  color: Colors.black,
                ), // icon is 48px widget.
              ), // icon is 48px widget.
              hintText: 'Short Answer',
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
                Question q=new Question();
                q.userId = userId;
                q.question=questionController.text;
                q.status=status;
                if(q.status==CytexConstants.QUESTION_ANSWERED){
                  q.answer=shortAnswerController.text;
                }

                _updateQuestion(question: q);
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
                    questionField,
                    SizedBox(height: 24.0),
                    statusField,
                    SizedBox(height: 24.0),
                    shortAnswerField,
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
                title: Text('Add Question'),
              ),
              body: LoadingScreen(
                child: form,
                inAsyncCall: _loadingVisible,
              )));
    }
  }

  void _onQuestionStatusItemSelected(String newValueSelected) {
    setState(() {
      this.status = newValueSelected;
      if (newValueSelected == CytexConstants.QUESTION_NOT_ANSWERED) {
        this._answerVisibility = false;
      } else {
        this._answerVisibility = true;
      }
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
