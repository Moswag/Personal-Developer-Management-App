import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/dev/friend_details_page.dart';
import 'package:cytex/models/company_account.dart';
import 'package:cytex/models/state.dart';
import 'package:cytex/service/cytex_service.dart';
import 'package:cytex/ui/screens/project/view_projects.dart';
import 'package:cytex/util/auth.dart';
import 'package:cytex/util/state_widget.dart';
import 'package:flutter/material.dart';

import 'package:cytex/ui/screens/test/add_file.dart';
import 'package:cytex/ui/screens/test/upload_image.dart';
import 'account/view_my_account.dart';
import 'business/view_businesses.dart';
import 'disturbance/view_disturbances.dart';
import 'ideas/view_ideas.dart';
import 'learnt/view_learnt.dart';
import 'payment/view_payments.dart';
import 'project/upload_my_file.dart';
import 'proposals/view_proposals.dart';
import 'question/view_questions.dart';
import 'sign_in.dart';
import 'spending/view_spending.dart';
import 'technology/view_technologies.dart';
import 'todo/view_todos.dart';

class DrawerOnly extends StatelessWidget {
  DrawerOnly({this.auth, this.onSignedOut});

  final Auth auth;
  final VoidCallback onSignedOut;

  StateModel appState;
  bool _loadingVisible = false;

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
      final email = appState?.firebaseUserAuth?.email ?? '';
      final name = appState?.user?.firstName ?? '';
      final surname = appState?.user?.lastName ?? '';







      void _signOut() async {
        try {
          await Auth.signOut();
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new SignInScreen()));
        } catch (e) {
          print(e);
        }
      }

      void showAlertDialog() {
        AlertDialog alertDialog = AlertDialog(
            title: Text('Status'),
            content: Text(
                'Are you sure you want to logout from Project Manager App'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
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
                          _signOut(); //signout
                        },
                      ),
                      Container(
                        width: 5.0,
                      ),
                      new FlatButton(
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
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))
            ]);

        showDialog(context: context, builder: (_) => alertDialog);
      }

      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(name + ' ' + surname),
              accountEmail: Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage(CytexConstants.DRAWER_LOGO),
              ),
            ),
            new ListTile(
              leading: Icon(Icons.book),
              title: new Text('Project'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new ViewProjects()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.colorize),
              title: new Text('Proposal'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewProposals()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.business),
              title: new Text('Business'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewBusiness()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.payment),
              title: new Text('Payment'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewPayments()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.note),
              title: new Text('Idea'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewIdeas()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.description),
              title: new Text('Learnt'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewLearnt()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.question_answer),
              title: new Text('Question'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => ViewQuestions()));
              },
            ),
            new ListTile(
              leading: Icon(Icons.clear_all),
              title: new Text('Technology'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ViewTechnologies())); //ViewSales(title: 'Sales')));
              },
            ),
            new ListTile(
              leading: Icon(Icons.stop),
              title: new Text('Disturbance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ViewDisturbances())); //ViewSales(title: 'Sales')));
              },
            ),
            new ListTile(
              leading: Icon(Icons.today),
              title: new Text('Todo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ViewTodos())); //ViewSales(title: 'Sales')));
              },
            ),
            new ListTile(
              leading: Icon(Icons.monetization_on),
              title: new Text('Spending'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ViewSpending())); //ViewSales(title: 'Sales')));
              },
            ),
            new ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: new Text('My Account'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            ViewMyAccount())); //ViewSales(title: 'Sales')));
              },
            ),
            new ListTile(
              leading: Icon(Icons.developer_mode),
              title: new Text('About Developer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            AboutDev())); // ListPage(title: 'Sales in Mass',)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.all_out),
              title: new Text('Logout'),
              onTap: () {
                //Navigator.pop(context);
                showAlertDialog(); // _signOut();
              },
            )
          ],
        ),
      );
    }
  }
}
