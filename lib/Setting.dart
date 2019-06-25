import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera.dart';

// A screen that allows users to take a picture using a given camera
class Setting extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<Setting> {
  final myController = TextEditingController();
  String number = "";
  String _currency = "USA";
  var prefs;
  bool _voice = true;
  final list = ['USD', 'INR', 'EUR', 'GBP', 'CHF', 'CAD'];

  void getPreference() async {
    prefs = await SharedPreferences.getInstance();
    print(_currency);
    print(_voice);
    setState(() {
      _currency = prefs.getString('currency') ?? 'USD';
      _voice = prefs.getBool('voice') ?? true;
    });
    
    print(_currency);
    print(_voice);
  }

  void _onChanged1(bool value) {
    // write
    prefs.setBool('voice', value);
    setState(() => _voice = value);
  }

  Widget navigateToCamera(){

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("checking");
    _currency = "USA";
    _voice = true;
    getPreference();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap:()=> Navigator.of(context).pop(true),
              child: Row(
                children: <Widget>[
                  Padding(
              padding: const EdgeInsets.all(1),
              child: Icon(FontAwesomeIcons.camera, color: Color(0xFF769cdb)),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Icon(FontAwesomeIcons.arrowLeft,color: Color(0xFF769cdb),),
            ),
                ]
              )
            ),
            
            Padding(
              padding: const EdgeInsets.only(left:15.0),
              child: Icon(FontAwesomeIcons.cog, color: Color(0xFF769cdb),),
            ),
            Text(
              'Setting',
              style: TextStyle(color: Color(0xFF769cdb), fontSize: 30.0),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.blue),
      ),
     
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  color: Colors.grey,
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 20.0,),
                    Icon(FontAwesomeIcons.dollarSign, color: Colors.black,),
                    Text(
                      "Select Currency",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      width: 60.0,
                    ),
                    Container(
                      width: 100.0,
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 7.0, top: 15.0, bottom: 0),
                        child: DropdownButton<String>(
                          value: _currency,
                          onChanged: (String newValue) {
                            // write
                            prefs.setString('currency', newValue);
                            setState(() {
                              _currency = newValue == null ? 'USA' : newValue;
                            });
                          },
                          items: list.map<DropdownMenuItem<String>>((String value) {
                            print(value);
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 25.0),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 10,
                ),
                SwitchListTile(
                  value: _voice == null ? true : _voice,
                  onChanged: _onChanged1,
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.volume_up
                      ),
                      Text('Turn on voice response',
                          style:
                              new TextStyle(color: Colors.black, fontSize: 20.0)),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }
}
