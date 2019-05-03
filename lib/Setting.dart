import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:async';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

// A screen that allows users to take a picture using a given camera
class Setting extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<Setting> {
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  String number = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
//            Uri asd = Uri.parse("tel://"+number);
//            print(asd);
//            AndroidIntent intent = AndroidIntent(
//              action: 'ACTION_CALL',
//              data: "tel://"+number,
//            );
//            await intent.launch();
          print(number.length);
          if(number.length  == 10){

              launch("tel://"+number);
          }
        },
        backgroundColor: Colors.green,
        mini: false,
        child: Icon(Icons.call),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 200),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: myController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some number';
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, we want to show a Snackbar
                          setState(() {
                            number = myController.text;
                          });
                          print(_formKey.currentContext.toString());
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                  Text(number),
                ]),
          ),
        ),
      ),
    );
  }
}
