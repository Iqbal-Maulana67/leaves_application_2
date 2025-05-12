import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/camera_page.dart';
import 'package:leaves_classification_application_nimas/data/plant_list.dart';
import 'package:leaves_classification_application_nimas/history_page.dart';
import 'package:leaves_classification_application_nimas/languages_page2.dart';
import 'package:leaves_classification_application_nimas/rating_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
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

class _HomePage extends State<HomePage> {
  List<PlantList> _nearbyPlants = [];
  Placemark _devAddress = Placemark();

  List<PlantList> getNearbyPlants(Position userPos, double radiusInMeters) {
    return plantData.where((plant) {
      double distance = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        plant.lat,
        plant.lng,
      );
      return distance <= radiusInMeters;
    }).toList();
  }

  void _findNearbyPlants() async {
    try {
      Position pos = await _getCurrentLocation();
      print("POSISI USER: ${pos.latitude}, ${pos.longitude}");

      List<PlantList> nearby = getNearbyPlants(pos, 5000);
      print("Nearby: $nearby");

      setState(() {
        _nearbyPlants = nearby;
      });
    } catch (e) {
      print("Error get location: $e");
    } // 5 km
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

  final PageController _pageController = PageController(viewportFraction: 0.6);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _findNearbyPlants();
    _findAddress();
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
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icon_map.png",
                      height: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      _devAddress.locality == null
                          ? 'Loading...'
                          : '${_devAddress.locality}, ${_devAddress.administrativeArea}',
                      style: TextStyle(
                          fontFamily: "DMSans",
                          fontSize: 14,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                margin: EdgeInsets.only(top: 30),
                alignment: Alignment.centerLeft,
                child: Text(
                  "${AppLocalizations.of(context)!.hi_there}\n${AppLocalizations.of(context)!.what_plant}",
                  style: TextStyle(
                      fontFamily: "DMSans",
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Image.asset(
                  "assets/images/bg_language.png",
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.05),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryPage()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 170, 151, 252),
                                        Color.fromARGB(255, 146, 124, 249)
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/icon_history.png",
                                    height: 100,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.history,
                                    style: TextStyle(
                                      fontFamily: "DMSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RatingPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 20, top: 10, bottom: 10, right: 40),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 144, 246, 205),
                                        Color.fromARGB(255, 67, 226, 164)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/icon_feedback.png",
                                    height: 80,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.feedback,
                                    style: TextStyle(
                                      fontFamily: "DMSans",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LanguagesPage2()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 30),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 27, 76, 215),
                                      Color.fromARGB(255, 81, 126, 246)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.06, 0.6]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/icon_lang2.png",
                                  height: 60,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.language2,
                                  style: TextStyle(
                                    fontFamily: "DMSans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CameraPage()));
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20, right: 20),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 135, 215, 252),
                                      Color.fromARGB(255, 94, 190, 240)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.06, 0.6]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/icon_identify.png",
                                  height: 100,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.identify,
                                  style: TextStyle(
                                    fontFamily: "DMSans",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.only(
                    top: 10, left: MediaQuery.sizeOf(context).width * 0.05),
                decoration: BoxDecoration(color: Colors.white),
                child: Text(
                  AppLocalizations.of(context)!.plant_around,
                  style: TextStyle(
                      fontFamily: "DMSans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 80,
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: _nearbyPlants.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : PageView.builder(
                          itemCount: _nearbyPlants.length,
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            final plant = _nearbyPlants[index];
                            return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 43, 83, 190),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 15),
                                      child: Image.asset(
                                        "assets/images/icon_leaves.png",
                                        height: 30,
                                      ),
                                    ),
                                    Container(
                                      child: AutoSizeText(
                                        plant.getLocalizedPlantName(
                                            context, plant.nameKey),
                                        style: TextStyle(
                                          fontFamily: "DMSans",
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ));
                          },
                        )),
              Expanded(
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
