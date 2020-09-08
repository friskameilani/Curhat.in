import 'package:curhatin/pages/forgotPassword.dart';
import 'package:curhatin/tabRoutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  bool _isHidePassword = true;
  void _toggle() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  String error = '';
  final linearGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 125, 222, 157),
      Color.fromARGB(255, 25, 184, 188)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  titleField(),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please type an email';
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    obscureText: _isHidePassword,
                    validator: (input) {
                      if (input.length < 6) {
                        return 'Your password needs to be at least 6 characters';
                      }
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _toggle();
                          },
                          child: Icon(
                            _isHidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _isHidePassword
                                ? Colors.grey
                                : Color(0xFF17B7BD),
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  ),
                  logInButton(),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotPassword()));
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ])),
          ),
        ));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      // TODO: Login to Firebase
      formState.save();
      try {
        dynamic user = await _auth.signInWithEmailPassword(_email, _password);
        if (user == null) {
          // setState(() => error = 'Could Not Sign in with those credentials');
          return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Error Logging In'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Sorry, we could not sign in with those credentials'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
              });
        } else {
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => TabRoutes()));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => TabRoutes()),
              (Route<dynamic> route) => false);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Widget titleField() {
    return Column(
      children: [
        Container(
          child: Text(
            "Hello",
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
                foreground: Paint()..shader = linearGradient),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: Text(
            "Login first to continue",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget logInButton() {
    return RaisedButton(
      onPressed: signIn,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Ink(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8FEEBF),
                Color(0xFF17B7BD),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(80.0))),
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0,
              minHeight: 44.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Log in',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
