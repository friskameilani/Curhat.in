import 'package:flutter/material.dart';
import 'package:curhatin/pages/resetPassword.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool val = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top:10),),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));},
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Ganti Password',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.navigate_next),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    children: [
                    Divider(
                      color: Colors.grey[800],
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Push Notifications',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                height: 2),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Switch(
                            value: val,
                            onChanged: (bool e) => switchButton(e),
                            activeColor: Colors.greenAccent,
                          ),
                        )
                      ],
                    ),
                    Divider(
                    color: Colors.grey[800],
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Allow Access to My Contacts',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                height: 2),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Switch(
                            value: val,
                            onChanged: (bool e) => switchButton(e),
                            activeColor: Colors.greenAccent,
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
          ])),
    );
  }

  void switchButton(bool e){
    setState(() {
      if(e) {
        val = true;
        e = true;
      } else {
        val = false;
        e = false;
      }
    });
  }
}
