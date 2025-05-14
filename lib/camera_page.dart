import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:leaves_classification_application_nimas/db/history_db.dart';
import 'package:leaves_classification_application_nimas/results/brotowali_result.dart';
import 'package:leaves_classification_application_nimas/results/pegagan_result.dart';
import 'package:leaves_classification_application_nimas/results/rambusa_result.dart';
import 'package:leaves_classification_application_nimas/results/rumput_minjangan_result.dart';
import 'package:leaves_classification_application_nimas/results/sembung_rambat_result.dart';
import 'package:leaves_classification_application_nimas/results/tumpang_air_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Placemark _devAddress = Placemark();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
    _findAddress();
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

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Choosed Image: ${image.path}')),
      // );
    }
  }

  Future<void> _uploadImage() async {
    if (_capturedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose or take photo before identify.')),
      );
      return;
    }

    var uri = Uri.parse("http://167.99.66.37:8000//api/predict-id/");
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
        HistoryDatabase.insertHistory(
            "plantName_pegagan",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PegaganResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "brotowali") {
        HistoryDatabase.insertHistory(
            "plantName_brotowali",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrotowaliResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "rambusa") {
        HistoryDatabase.insertHistory(
            "plantName_rambusa",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RambusaResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "rumput minjangan") {
        HistoryDatabase.insertHistory(
            "plantName_rumputMinjangan",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RumputMinjanganResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "sembung rambat") {
        HistoryDatabase.insertHistory(
            "plantName_sembungRambat",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SembungRambatResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
            ),
          ),
        );
      }
      if (plantClass.toLowerCase() == "tumpang air") {
        HistoryDatabase.insertHistory(
            "plantName_tumpangAir",
            '${_devAddress.locality}, ${_devAddress.administrativeArea}',
            trimmedAccuracy.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TumpangAirResult(
              accuracy: trimmedAccuracy,
              imgPath: _capturedImagePath!,
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

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Placemark> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print(
            'Alamat: ${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}');
        return place;
      }
    } catch (e) {
      print('Error saat reverse geocoding: $e');
    }
    return Future.error('Location is not found');
  }

  void _findAddress() async {
    try {
      Position pos = await _getCurrentLocation();
      Placemark place = await _getAddressFromLatLng(pos);
      setState(() {
        _devAddress = place;
      });
    } catch (e) {
      print("Error get location: $e");
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
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
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
                                    if (_capturedImagePath == null ||
                                        _capturedImagePath!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Please insert the image using camera or file')),
                                      );
                                    } else {
                                      _uploadImage();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         TumpangAirResult(
                                      //       accuracy: 42.7,
                                      //       imgPath: _capturedImagePath!,
                                      //     ),
                                      //   ),
                                      // );
                                    }
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
                                  AppLocalizations.of(context)!.predict,
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
                                  AppLocalizations.of(context)!.refresh,
                                  textAlign: TextAlign.center,
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
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context)!.upload,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "DMSans",
                                      fontSize: 14,
                                    ),
                                    softWrap: true, // Aktifkan wrap otomatis
                                    overflow: TextOverflow
                                        .visible, // Pastikan teks tetap terlihat
                                  ),
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
