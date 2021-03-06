import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera.dart';


Future<void> main() async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cam eras
  final firstCamera = cameras.first;


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(
            camera: firstCamera,
          )
  ),
  );
}




