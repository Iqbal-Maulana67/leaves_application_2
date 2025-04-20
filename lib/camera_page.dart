import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaves_classification_application_nimas/result_page.dart';
import 'package:http/http.dart' as http;
import 'package:leaves_classification_application_nimas/results/brotowali_result.dart';
import 'package:leaves_classification_application_nimas/results/pegagan_result.dart';
import 'package:leaves_classification_application_nimas/results/rambusa_result.dart';
import 'package:leaves_classification_application_nimas/results/rumput_minjangan_result.dart';
import 'package:leaves_classification_application_nimas/results/sembung_rambat_result.dart';
import 'package:leaves_classification_application_nimas/results/tumpang_air_result.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _takePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImagePath = photo.path;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _capturedImagePath = image.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Choosed Image: ${image.path}')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_capturedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pilih atau ambil gambar terlebih dahulu')),
      );
      return;
    }

    var uri = Uri.parse("http://192.168.1.5:8000/api/predict-id/");
    var request = http.MultipartRequest('POST', uri)
      ..files
          .add(await http.MultipartFile.fromPath('gmbr', _capturedImagePath!));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      String plantClass = jsonResponse["class"];
      double accuracy = jsonResponse["accuracy"];
      double trimmedAccuracy = double.parse(accuracy.toStringAsFixed(1));

      if (plantClass.toLowerCase() == "pegagan") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PegaganResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "brotowali") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrotowaliResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "rambusa") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RambusaResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "rumput minjangan") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RumputMinjanganResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "sembung rambat") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SembungRambatResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "tumpang air") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TumpangAirResult(
              accuracy: trimmedAccuracy,
            ),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hasil: $plantClass (${accuracy.toStringAsFixed(2)}%)"),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah gambar')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 20, 69, 200)),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              alignment: Alignment.centerLeft,
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          spreadRadius: 0.5,
                          blurRadius: 1)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Image.asset(
                "assets/images/bg_language.png",
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.65,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20.0),
                    child: _capturedImagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              File(_capturedImagePath!),
                              fit: BoxFit.cover,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          )
                        : _isCameraInitialized
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.7,
                                        child:
                                            CameraPreview(_cameraController!),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    child: GestureDetector(
                                      onTap: _takePhoto,
                                      child: Container(
                                        child: Image.asset(
                                            "assets/images/icon_snap.png",
                                            height: 50),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : const Center(child: CircularProgressIndicator()),
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.sizeOf(context).width * 0.05),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResultPage()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              spreadRadius: 0.5,
                                              offset: Offset(1, 1))
                                        ]),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/icon_classify.png",
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Predict",
                                  style: TextStyle(fontFamily: "DMSans"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.sizeOf(context).width * 0.1),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => {
                                    setState(() {
                                      _capturedImagePath = null;
                                    })
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              spreadRadius: 0.5,
                                              offset: Offset(1, 1))
                                        ]),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/icon_refresh.png",
                                          height: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Refresh",
                                  style: TextStyle(fontFamily: "DMSans"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.sizeOf(context).width * 0.05),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 1,
                                              spreadRadius: 0.5,
                                              offset: Offset(1, 1))
                                        ]),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/icon_upload.png",
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Upload",
                                  style: TextStyle(fontFamily: "DMSans"),
                                )
                              ],
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(color: Colors.white),
            ))
          ],
        ),
      )),
    );
  }
}
