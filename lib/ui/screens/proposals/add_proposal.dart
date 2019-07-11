import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/cytex_routes.dart';
import 'package:cytex/models/project.dart';
import 'package:cytex/models/proposal.dart';
import 'package:cytex/models/state.dart';
import 'package:cytex/service/cytex_service.dart';
import 'package:cytex/ui/screens/sign_in.dart';
import 'package:cytex/ui/widgets/loading.dart';
import 'package:cytex/util/alert_dialog.dart';
import 'package:cytex/util/state_widget.dart';
import 'package:cytex/util/validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:path/path.dart' as Path;
import 'package:mime/mime.dart';

import 'view_proposals.dart';

class AddProposal extends StatefulWidget {
  AddProposal({this.email});
  final String email;

  @override
  State createState() => _AddProposalState();
}

class _AddProposalState extends State<AddProposal> {
  StateModel appState;
  bool _autoValidate = false;
  bool _loadingVisible = false;
  bool _categoryVisibility = true;
  String startDate, endDate;
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  File file;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();



  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        _paths = null;
        file = await FilePicker.getFile(type: FileType.ANY);
        _path = file.path;
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  String getExtension(String basename) {
    return lookupMimeType(basename);
  }

  Future _addProposal({Proposal proposal,String amount}) async {
    //verifying userType is Direct or Franchise to determine category

    proposal.status = CytexConstants.PROJECT_PENDING;
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            Path.basename(file.path);
        String myChild = CytexConstants.DOCS_PROPOSAL + fileName;
        final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(myChild);
        final StorageUploadTask task = firebaseStorageRef.putFile(file);
        StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
        String url = await storageTaskSnapshot.ref.getDownloadURL();

        // String url = firebaseStorageRef.getDownloadURL().toString();

        if (url != null) {
          proposal.documentUrl = url;
          proposal.amount=double.parse(amount);

          var id = utf8.encode(proposal.title +
              proposal.description +
              DateTime.now().millisecondsSinceEpoch.toString()); // data being hashed

          proposal.id = sha1.convert(id).toString();

          MyService.addProposal(proposal).then((onValue) {
            if (onValue) {
              AlertDiag.showAlertDialog(context, 'Status',
                  'Proposal Successfully Added', MyRoutes.VIEW_PROPOSALS);
            } else {
              AlertDiag.showAlertDialog(
                  context,
                  'Status',
                  'Failed to add Proposal, please contact developer',
                  MyRoutes.VIEW_PROJECTS);
            }
          });
        }
      } catch (e) {
        print("Adding Error: $e");
        Flushbar(
                title: "Adding Proposal Error",
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

      String docName =
          _path != null ? Path.basename(file.path) : 'Please pick a file';

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
              'Proposal',
              style: TextStyle(
                  color: Colors.white, fontSize: 12, fontFamily: 'Roboto'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Add Proposal',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Icon(
              Icons.note,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
      );



      final docField = Container(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(children: <Widget>[
            new Expanded(
              flex: 1,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Pick Doc',
                  ),
                  onPressed: () {
                    _openFileExplorer();
                  }),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                  child: Text(
                    docName,
                  ),
                )),
          ]));

      final titleField = TextFormField(
        autofocus: false,
        keyboardType: TextInputType.text,
        controller: titleController,
        validator: Validator.validateName,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.title,
              color: Colors.black,
            ), // icon is 48px widget.
          ), // icon is 48px widget.
          hintText: 'Title',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      );
      final descriptionField = Visibility(
        visible: _categoryVisibility,
        child: TextFormField(
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: descriptionController,
            validator: Validator.validateField,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ), // icon is 48px widget.
              ), // icon is 48px widget.
              hintText: 'Client',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            )),
      );

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
                Proposal prop=new Proposal();
                prop.userId = userId;
                prop.title = titleController.text;
                prop.description = descriptionController.text;
                String amnt=amountController.text;


                _addProposal(proposal: prop, amount:amnt);
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
                    titleField,
                    SizedBox(height: 24.0),
                    descriptionField,
                    SizedBox(height: 24.0),
                    amountField,
                    SizedBox(height: 24.0),
                    docField,
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
                title: Text('Add Proposal'),
              ),
              body: LoadingScreen(
                child: form,
                inAsyncCall: _loadingVisible,
              )));
    }
  }

  void _showAlertDialog(String title, String messge) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(messge),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Theme.of(context).primaryColorDark,
          textColor: Theme.of(context).primaryColorLight,
          child: Text(
            'Ok',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => ViewProposals()));
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => alertDialog);
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
