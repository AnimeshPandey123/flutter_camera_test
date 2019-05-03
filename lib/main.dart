import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera.dart';
import 'Setting.dart';

Future<void> main() async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras
  final firstCamera = cameras.first;


  runApp(
    MaterialApp(
      home: PageView(
        children: <Widget>[
          TakePictureScreen(
            camera: firstCamera,
          ),
          Setting(),
      ]
    ),
  ),
  );
}




