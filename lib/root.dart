import 'package:curhatin/pages/welcome.dart';
import 'package:curhatin/tabRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/pages/landingPage.dart';

import 'models/user.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user == null) {
      return LandingPage();
    } else {
      return TabRoutes(
          // user: user
          );
    }
  }
}
