import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cytex/constants/cytex_constants.dart';
import 'package:cytex/constants/db_constants.dart';
import 'package:cytex/models/business.dart';
import 'package:cytex/models/company_account.dart';
import 'package:cytex/models/disturbance.dart';
import 'package:cytex/models/idea.dart';
import 'package:cytex/models/learnt.dart';
import 'package:cytex/models/payment.dart';
import 'package:cytex/models/project.dart';
import 'package:cytex/models/proposal.dart';
import 'package:cytex/models/question.dart';
import 'package:cytex/models/spending.dart';
import 'package:cytex/models/technology.dart';
import 'package:cytex/models/timetable.dart';
import 'package:cytex/models/todo.dart';

class MyService {
  static Future<bool> addProject(Project project) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_PROJECTS + "/${project.id}")
          .setData(project.toJson());
      print("Project added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addProposal(Proposal proposal) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_PROPOSALS + "/${proposal.id}")
          .setData(proposal.toJson());
      print("Proposal added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addBusiness(Business business) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_BUSINESS + "/${business.id}")
          .setData(business.toJson());
      print("Business added");

      //check company account
      checkCompanyAccount(business.userId).then((onValue) {
        if (!onValue) {
          addCompanyAccount(new CompanyAccount(
              userId: business.userId,
              balance: 0,
              allTransactionAmounts: business.amount,
              date: business.date));
        } else {
          //get company account
          getCompanyAccount(business.userId).then((QuerySnapshot snapshot) {
            if (snapshot.documents.isNotEmpty) {
              var account = snapshot.documents[0].data;
              CompanyAccount acc = new CompanyAccount();
              acc.allTransactionAmounts =
                  account['allTransactionAmounts'] + business.amount;
              updateCompanyAccount(acc, snapshot.documents[0].reference, false);
            }
          });
          //update company account

        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkCompanyAccount(String userId) async {
    bool exists = false;
    try {
      await Firestore.instance
          .document(DBConstants.TABLE_COMPANY_ACCOUNT + "/$userId")
          .get()
          .then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addCompanyAccount(CompanyAccount acc) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_COMPANY_ACCOUNT + "/${acc.userId}")
          .setData(acc.toJson());
      print("Company Account added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addDisturbance(Disturbance disturbance) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_DISTURBANCES + "/${disturbance.id}")
          .setData(disturbance.toJson());
      print("Disturbance added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addIdea(Idea idea) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_IDEAS + "/${idea.id}")
          .setData(idea.toJson());
      print("Idea added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addLearnt(Learnt learnt) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_LEARNT + "/${learnt.id}")
          .setData(learnt.toJson());
      print("Learnt added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addPayment(Payment payment) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_PAYMENTS + "/${payment.id}")
          .setData(payment.toJson());
      print("Payment added");

      //update business on payment
      getBusiness(payment.client, payment.nature)
          .then((QuerySnapshot snapshot) {
        if (snapshot.documents.isNotEmpty) {
          var bus = snapshot.documents[0].data;
          Business business = new Business();
          business.amount = bus["amount"];
          business.balance = bus["balance"] - payment.amount;
          business.status = bus["status"];
          business.userId=bus["userId"];

          if (business.balance == 0.0) {
            business.status = CytexConstants.BUSINESS_PAID;
          }

          updateBusiness(business, snapshot.documents[0].reference);

          //update Company account
          getCompanyAccount(business.userId).then((QuerySnapshot snapshot) {
            if (snapshot.documents.isNotEmpty) {
              var account = snapshot.documents[0].data;
              CompanyAccount acc = new CompanyAccount();
              acc.balance = account['balance'] + payment.amount;
              updateCompanyAccount(acc, snapshot.documents[0].reference, true);
            }
          });

          return true;
        } else {
          return false;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addQuestion(Question question) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_QUESTIONS + "/${question.id}")
          .setData(question.toJson());
      print("Question added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateQuestion(
      Question  qstn, final index) async {
    try {
      print("updating question");
      if (qstn.status==CytexConstants.QUESTION_NOT_ANSWERED) {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "question": qstn.question,
          });
        });
      } else {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "answer": qstn.answer,
            "status": qstn.status
          });
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addSpending(Spending spending) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_SPENDING + "/${spending.id}")
          .setData(spending.toJson());
      print("Spending added");
      getCompanyAccount(spending.userId).then((QuerySnapshot snapshot) {
        if (snapshot.documents.isNotEmpty) {
          var account = snapshot.documents[0].data;
          CompanyAccount acc = new CompanyAccount();
          acc.balance = account['balance'] - spending.amount;
          updateCompanyAccount(acc, snapshot.documents[0].reference, true);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addTechnology(Technology technology) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_TECHNOLOGIES + "/${technology.id}")
          .setData(technology.toJson());
      print("Technology added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addTimetable(Timetable timetable) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_TIMETABLES + "/${timetable.id}")
          .setData(timetable.toJson());
      print("Timetable added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addTodo(Todo todo) async {
    try {
      Firestore.instance
          .document(DBConstants.TABLE_TODOS + "/${todo.id}")
          .setData(todo.toJson());
      print("Todo added");
      return true;
    } catch (e) {
      return false;
    }
  }

  static getBusiness(String clint, String nature) {
    return Firestore.instance
        .collection(DBConstants.TABLE_BUSINESS)
        .where('client', isEqualTo: clint)
        .where('nature', isEqualTo: nature)
        .where('status', isEqualTo: CytexConstants.BUSINESS_OWING)
        .limit(1)
        .getDocuments();
  }

  static Future<bool> updateBusiness(Business business, final index) async {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference,
            {"balance": business.balance, "status": business.status});
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static getCompanyAccount(String userId) {
    return Firestore.instance
        .collection(DBConstants.TABLE_COMPANY_ACCOUNT)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .getDocuments();
  }


  static Future<CompanyAccount> getMyAccountBalance(String userId) async {
    CompanyAccount acc = new CompanyAccount();
   await getCompanyAccount(userId).then((QuerySnapshot snapshot) {
      if (snapshot.documents.isNotEmpty) {
        var account = snapshot.documents[0].data;
        acc.balance = account['balance'];
        acc.allTransactionAmounts = account['allTransactionAmounts'];


      }
    });

    return acc;
  }



  static Future<bool> updateCompanyAccount(
      CompanyAccount acc, final index, bool isBalance) async {
    try {
      if (isBalance) {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "balance": acc.balance,
          });
        });
      } else {
        Firestore.instance.runTransaction((Transaction transaction) async {
          DocumentSnapshot snapshot = await transaction.get(index);
          await transaction.update(snapshot.reference, {
            "allTransactionAmounts": acc.allTransactionAmounts,
          });
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }


}
