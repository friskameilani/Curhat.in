import 'package:curhatin/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/components/themeApp.dart';
import 'package:curhatin/models/user.dart';

class ResetPasswordPage extends StatefulWidget {
  final User user;
  ResetPasswordPage({ this.user });
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      icon: Icon(Icons.arrow_back_ios, semanticLabel: "Setting", color: Colors.white,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text("Setting", style: TextStyle(color: Colors.white, fontSize: 20),)
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
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                          height: 10,
                        ),
                        gantiPassword(),
                      ]))),
          OutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
              },
            textColor: Colors.lightBlueAccent,
            color: Colors.white70,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0),),
            child: const Text(
              'Save',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget gantiPassword(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (input) {
              return "hello";
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(labelText: 'Password Lama',),
            obscureText: true,
            style: TextStyle(fontSize: 13),
          ),
          TextFormField(
            validator: (input) {
              return "hello";
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(labelText: 'Password Baru'),
            obscureText: true,
            style: TextStyle(fontSize: 13),
          ),
          TextFormField(
            validator: (input) {
              return "hello";
            },
            onSaved: (input) => _password = input,
            decoration: InputDecoration(labelText: 'Ketik Ulang Password Baru'),
            obscureText: true,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}