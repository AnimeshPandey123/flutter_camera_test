import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TtsState { playing, stopped }

class DisplayPictureScreen extends StatefulWidget {
  @override
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
  DisplayPictureScreenState createState() => new DisplayPictureScreenState();
}

// A Widget that displays the picture taken by the user
class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  List _recognitions;
  Future<List> _anoRec;
  File _image;
  String url = 'http://192.168.0.104:5000/uploader';
  var data;
  String par;
  var arr;
   String _currency;
  var prefs;
  bool _voice;
  
  FlutterTts flutterTts = new FlutterTts();
  TtsState ttsState = TtsState.stopped;

  Future _speak(String str) async{
      print(_voice);
      if(_voice == false){
        return;
      }
      var result = await flutterTts.speak(str);
      if (result == 1) setState(() => ttsState = TtsState.playing);
    }

    Future<String> getData() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _currency = prefs.getString('currency') ?? 'USD';
        _voice = prefs.getBool('voice') ?? true;
      });
      return _currency;
    }

  void _upload() {
    // if (file == null) return;
    // String base64Image = base64Encode(File(widget.imagePath).readAsBytesSync());
    // String fileName = file.path.split("/").last;

    // http.post(url, body: {
    //   "image": base64Image,
    //   "name": "file",
    // }).then((res) {
    //   data = json.decode(res.body);
    // }).catchError((err) {
    //   print(err);
    // });

    //  http.get("http://192.168.0.104:5000/testing").then((res) {
      
    //   setState(() {
    //     data = json.decode(res.body);
    //   });
    //   print(data);
    // }).catchError((err) {
    //   print(err);
    // });
    _image = File(widget.imagePath);
    Dio dio = new Dio();
    FormData formdata = new FormData(); // just like JS
    formdata.add("file", new UploadFileInfo(_image, basename(_image.path)));
    print(_currency);
    formdata.add("currency", _currency);
    print(_currency);
    dio
        .post(url,
            data: formdata,
            options: Options(
                method: 'POST',
                responseType: ResponseType.plain // or ResponseType.JSON
                ))
        .then((response) => {
          setState((){
            data = response.data.toString();
            print(data);
            arr = jsonDecode(data);
            print(arr);
            print(arr['value']);
            String str = arr['val_par'];
            _speak(str);

          })
          
        })
        .catchError((error) => print(error));
  }

  Future<void> _ackAlert(BuildContext context, String conversion_paragraph) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversion', style: TextStyle(fontSize: 25.0)),
          content: Container(
            height: 120.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        conversion_paragraph,
                        style:
                            TextStyle(fontSize: 25.0, color: Colors.blueAccent),
                      ),
                    )
                  ],
                )
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
          ],
        );
      },
    );
  }

  Future recognizeImage(path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  Future<List> getPredictions() async {
    String res = await Tflite.loadModel(
      model: "assets/models/test2.tflite",
      labels: "assets/labels.txt",
    );

    var recognitions = Tflite.runModelOnImage(
        path: widget.imagePath, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    setState(() {
      _anoRec = recognitions;
      print(_anoRec);
      print(recognitions);
      debugPrint(json.encode(_anoRec));
    });

    return recognitions;
  }

  @override
  initState() {
    super.initState();
    getData().then((String check){
      _upload();
    });
    
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display the Picture'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Color(0xFF18D191)),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                print("Dragged");
              },
              child: Container(
                  child: Center(
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Image.file(
                              File(widget.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 270.0,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 50.0, left: 70.0),
                          child: Text(
                            arr['value'],
                            style: new TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: "Times New Roman"),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Positioned(
                      top: 350,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 08, right: 08, top: 10, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                _ackAlert(context, arr['paragraph']);
                                _speak(arr['paragraph']);
                              },
                              child: new Container(
                                width: 340.0,
                                height: 70.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(40)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Convert",
                                      style: new TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.compare_arrows,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ),
    );
  }
}
