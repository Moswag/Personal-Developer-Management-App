import 'package:cytex/ui/screens/business/view_businesses.dart';
import 'package:cytex/ui/screens/disturbance/view_disturbances.dart';
import 'package:cytex/ui/screens/ideas/view_ideas.dart';
import 'package:cytex/ui/screens/learnt/view_learnt.dart';
import 'package:cytex/ui/screens/payment/view_payments.dart';
import 'package:cytex/ui/screens/question/view_questions.dart';
import 'package:cytex/ui/screens/spending/view_spending.dart';
import 'package:cytex/ui/screens/technology/view_technologies.dart';
import 'package:cytex/ui/screens/todo/view_todos.dart';
import 'package:flutter/material.dart';
import 'package:cytex/util/state_widget.dart';
import 'package:cytex/ui/theme.dart';
import 'package:cytex/ui/screens/home.dart';
import 'package:cytex/ui/screens/sign_in.dart';
import 'package:cytex/ui/screens/sign_up.dart';
import 'package:cytex/ui/screens/forgot_password.dart';

import 'constants/cytex_routes.dart';
import 'routing.dart';
import 'ui/screens/project/view_projects.dart';
import 'ui/screens/proposals/view_proposals.dart';
import 'util/auth.dart';

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Manager',
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      home: RootPage(
        auth: Auth(),
      ),
      routes: {
        //  '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        MyRoutes.VIEW_PROJECTS: (context) => ViewProjects(),
        MyRoutes.VIEW_PROPOSALS: (context) => ViewProposals(),
        MyRoutes.VIEW_BUSINESS: (context) => ViewBusiness(),
        MyRoutes.VIEW_PAYMENTS: (context) => ViewPayments(),
        MyRoutes.VIEW_IDEAS: (context) => ViewIdeas(),
        MyRoutes.VIEW_LEARNT: (context) => ViewLearnt(),
        MyRoutes.VIEW_QUESTIONS: (context) => ViewQuestions(),
        MyRoutes.VIEW_TECHNOLOGIES: (context) => ViewTechnologies(),
        MyRoutes.VIEW_DISTURBANCES: (context) => ViewDisturbances(),
        MyRoutes.VIEW_TODOS: (context) => ViewTodos(),
        MyRoutes.VIEW_SPENDINGS: (context) => ViewSpending(),
      },
    );
  }
}

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}
