import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';
import 'package:cytex/ui/screens/home.dart';
import 'package:flutter/material.dart';

class UserManagement{



  authoriseAccess(BuildContext context) async{

    FirebaseAuth.instance.currentUser().then((user){
      Firestore.instance.document("users/${user.uid}").get().then((doc){
        if(doc.exists){
          if(doc.data['access']=='admin'){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>new HomeScreen()));
          }
          else{
            print('Not Authorised');
          }

        }
      });
    });


  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }
}