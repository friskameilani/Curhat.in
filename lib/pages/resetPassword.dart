import 'package:curhatin/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/components/themeApp.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/locator.dart';

class ResetPasswordPage extends StatefulWidget {
  final User user;
  ResetPasswordPage({this.user});
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  var _passwordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  bool checkCurrentPasswordValid = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              ThemeApp(),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          semanticLabel: "Setting",
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        "Setting",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  )),
            ],
          ),
          Card(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            'Ganti Password',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                          height: 10,
                        ),
                        gantiPassword(),
                      ]))),
          RaisedButton(
            onPressed: () async {
              var authService = locator.get<AuthService>();

              checkCurrentPasswordValid =
              await authService.validateCurrentPassword(
                  _passwordController.text);

              setState(() {});

              if (_formKey.currentState.validate() && checkCurrentPasswordValid) {
                authService.updateUserPassword(
                    _newPasswordController.text);
                Navigator.pop(context);
              }
            },
            child: Text("Save Profile"),
          )
        ],
      ),
    );
  }

  Widget gantiPassword() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: "Password",
              errorText: checkCurrentPasswordValid
                  ? null
                  : "Please double check your current password",
            ),
            controller: _passwordController,
          ),
          TextFormField(
            decoration:
            InputDecoration(hintText: "New Password"),
            controller: _newPasswordController,
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: "Repeat Password",
            ),
            obscureText: true,
            controller: _repeatPasswordController,
            validator: (value) {
              return _newPasswordController.text == value
                  ? null
                  : "Please validate your entered password";
            },
          )
        ],
      ),
    );
  }
}
