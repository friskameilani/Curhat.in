import 'package:curhatin/root.dart';
import 'package:curhatin/services/auth.dart';
import 'package:curhatin/setup/signIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/pages/splash.dart';
import 'package:curhatin/pages/welcome.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/root': (BuildContext context) => new RootPage(),
          '/welcome' : (BuildContext context) => new WelcomePage()
        },
          ),
    );
  }
}
