import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/db_constants.dart';
import 'package:cytex/ui/screens/drawer.dart';
import 'package:cytex/ui/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ViewMyAccount extends StatefulWidget {
  ViewMyAccount({this.user});

  final FirebaseUser user;

  @override
  State createState() => _ViewMyAccountState();
}

class _ViewMyAccountState extends State<ViewMyAccount> {
  @override
  Widget build(BuildContext context) {
    final makeBottom = Container(
      height: 55.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => SignInScreen()));
              },
            ),

          ],
        ),
      ),
    );

    return Scaffold(
        drawer: DrawerOnly(),
        appBar: new AppBar(
          title: new Text('Account'),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        bottomNavigationBar: makeBottom,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 160),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection(DBConstants.TABLE_COMPANY_ACCOUNT)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return new Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  return new TaskList(
                    document: snapshot.data.documents,
                  );
                },
              ),
            ),
            Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(CytexConstants.BACKGROUND_IMAGE),
                        fit: BoxFit.cover),
                    boxShadow: [
                      new BoxShadow(color: Colors.black, blurRadius: 8.0)
                    ],
                    color: Colors.blue),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'My Account',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Roboto'),
                    ),
                    Icon(
                      Icons.list,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                )),
          ],
        ));
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    ListView getNoteListView() {
      TextStyle titleStyle = Theme.of(context).textTheme.subhead;
      return ListView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int positon) {
          String balance = document[positon].data['balance'].toString();
          String allTransactionAmounts = document[positon].data['allTransactionAmounts'].toString();


          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: Container(
                decoration:
                BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.attach_money)),
                  title: Text('All Transactions: '+allTransactionAmounts,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Current Balance: ' +
                          balance,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal)),
                  onTap: () {
                    debugPrint("ListTile Tapped");
//                    Navigator.of(context).push(MaterialPageRoute(
//                        builder: (BuildContext context)=>new EditController(
//                          name:  name,
//                          email: email,
//                          nationalId: nationalId ,
//                          phonenumber: phonenumber,
//                          index: document[positon].reference,
//                        )));
                  },
                ),
              ));
        },
      );
    }

    return getNoteListView();
  }
}
