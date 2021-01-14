import 'package:flutter/material.dart';
import 'package:flutter_docskew_correction/view/Widgets/CustomButton.dart';
import 'dart:developer';
import 'package:huawei_ml/huawei_ml.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imagePath = "";

  void _initiateSkewCorrectionByCamera() async {
    final bool isCameraPermissionGranted =
        await MLPermissionClient().checkCameraPermission();

    if (isCameraPermissionGranted) {
      File image = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);

      setState(() {
        _imagePath = image.path;
      });
    } else {
      // request the permission
      await MLPermissionClient().requestCameraPermission();
    }
  }

  void _initiateSkewCorrectionByGallery() async {
    final bool isStoragePermissionGranted =
        await MLPermissionClient().checkReadExternalStoragePermission();

    if (isStoragePermissionGranted) {
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        _imagePath = image.path;
      });

      //skewCorrection();
    } else {
      // request the permission
      await MLPermissionClient().requestStoragePermission();
    }
  }

  void skewCorrection() async {

    if (_imagePath.isNotEmpty) {
      // Create an analyzer for skew detection.
      MLDocumentSkewCorrectionAnalyzer analyzer =
          new MLDocumentSkewCorrectionAnalyzer();

      // Get skew detection result asynchronously.
      MLDocumentSkewDetectResult detectionResult =
          await analyzer.asyncDocumentSkewDetect(_imagePath);

      // After getting skew detection results, you can get the corrected image by
      // using asynchronous call
      MLDocumentSkewCorrectionResult corrected =
          await analyzer.asyncDocumentSkewResult();

      // After recognitions, stop the analyzer.
      bool result = await analyzer.stopDocumentSkewCorrection();

      log('Path :' +
          corrected.imagePath +
          'Code :' +
          corrected.resultCode.toString());

      var path = await FlutterAbsolutePath.getAbsolutePath(corrected.imagePath);

      setState(() {
        _imagePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  bottom: 10.0, top: 10.0, right: 10.0, left: 10.0),
              child: Image.file(
                File(_imagePath),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onQueryChange: () => {
                  log('Skew button pressed'),
                  skewCorrection(),
                },
                buttonLabel: 'Skew Correction',
                disabled: _imagePath.isEmpty,
              ),
            ),
            CustomButton(
              onQueryChange: () => {
                log('Camera button pressed'),
                _initiateSkewCorrectionByCamera(),
              },
              buttonLabel: 'Camera',
              disabled: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                onQueryChange: () => {
                  log('Gallery button pressed'),
                  _initiateSkewCorrectionByGallery(),
                },
                buttonLabel: 'Gallery',
                disabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
