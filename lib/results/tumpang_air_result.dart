import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:leaves_classification_application_nimas/data/plant_list.dart';
import 'package:leaves_classification_application_nimas/models/tumpangAirList.dart';
import 'package:leaves_classification_application_nimas/widgets/indicator.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:leaves_classification_application_nimas/clips/result_clips.dart';

class TumpangAirResult extends StatefulWidget {
  final double accuracy;
  final String imgPath;

  const TumpangAirResult(
      {super.key, required this.accuracy, required this.imgPath});

  @override
  State<StatefulWidget> createState() => _TumpangAirResult();
}

class _TumpangAirResult extends State<TumpangAirResult> {
  final PopupController _popupLayerController = PopupController();
  final PageController _pageController = PageController(viewportFraction: 0.75);
  late final MapController _mapController = MapController();

  int _currentPage = 0;
  int _widgetDetail = 0;
  LatLng? _currentLocation;
  String _imgPath = "";
  double _accuracy = 0.0;

  final List<Marker> markers = [];
  final List<Map<String, dynamic>> plantMarkers = [];
  final List<Map<String, dynamic>> plants = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
    _loadPlants();
    _accuracy = widget.accuracy;
    _imgPath = widget.imgPath;

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  BoxDecoration _getDecoration(int index) {
    if (_currentPage == index) {
      return BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_benefit.png'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20.0));
    } else {
      // Halaman lain
      return BoxDecoration(
          color: Color.fromARGB(255, 59, 99, 203),
          borderRadius: BorderRadius.circular(20.0));
    }
  }

  Widget WidgetPreparation(int index) {
    if (index == 1) {
      return widgetPrepHerbal();
    } else if (index == 2) {
      return widgetPrepTea();
    } else if (index == 3) {
      return widgetPrepWound();
    }
    return widgetPrep();
  }

  String getLocalizedPlantName(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    final Map<String, String> allKeys = {
      'plantName_brotowali': localizations.brotowali,
      'plantName_pegagan': localizations.pegagan,
      'plantName_rambusa': localizations.rambusa,
      'plantName_rumputMinjangan': localizations.rumput_minjangan,
      'plantName_sembungRambat': localizations.sembung_rambat,
      'plantName_tumpangAir': localizations.tumpang_air,
      // Tambah key lainnya di sini
    };
    return allKeys[key] ?? key; // fallback jika key tidak ditemukan
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

  void _getLocation() async {
    try {
      Position pos = await _getCurrentLocation();

      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        print('Lokasi ${_currentLocation}');

        plantMarkers.add({
          'marker': Marker(
            point: LatLng(pos.latitude, pos.longitude),
            width: 20,
            height: 20,
            child: Icon(Icons.location_on, size: 20, color: Colors.red),
          ),
          'name': "Your Position"
        });
      });

      _mapController.move(LatLng(pos.latitude, pos.longitude), 15);
    } catch (e) {
      print("Gagal mendapatkan lokasi: $e");
    }
  }

  void _loadPlants() async {
    try {
      for (var plant in plantData) {
        plants.add({
          'marker': Marker(
              point: LatLng(plant.lat, plant.lng),
              width: 20,
              height: 20,
              child: Icon(Icons.location_on, size: 20, color: Colors.green),
              key: Key('marker-${plant.lat}-${plant.lng}')),
          'name': plant.nameKey
        });
      }
      setState(() {
        plantMarkers.addAll(plants);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 20, 69, 200)),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
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
              color: Colors.white,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.sizeOf(context).width, 300),
                    painter: PathBorderPainter(),
                  ),
                  ClipPath(
                    clipper: ResultClip(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(_imgPath)),
                            fit: BoxFit.cover),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: 300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          AppLocalizations.of(context)!.tumpang_air,
                          style: TextStyle(
                              fontFamily: "DMSans",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Peperomia pellucida",
                          style: TextStyle(
                              fontFamily: "DMSans",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SimpleCircularProgressBar(
                      size: 50,
                      maxValue: 100,
                      progressColors: [Colors.blue],
                      mergeMode: true,
                      animationDuration: 3,
                      backStrokeWidth: 5,
                      progressStrokeWidth: 5,
                      valueNotifier: ValueNotifier(_accuracy),
                      onGetText: (double value) {
                        value = double.parse(value.toStringAsFixed(1));
                        return Text("${value.toInt()}%");
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 2000),
              color: Colors.white,
              width: MediaQuery.sizeOf(context).width,
              child: WidgetPreparation(_widgetDetail),
            )
          ],
        )),
      ),
    );
  }

  Widget widgetPrep() {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 400,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _widgetDetail = 1;
                    });
                  },
                  child: Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: MediaQuery.sizeOf(context).width *
                            0.1, // Kurangi ukuran vertikalnya
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 170, 151, 252),
                            Color.fromARGB(255, 146, 124, 249)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .tumpang_air_herbal_drink_title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "DMSans",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .tumpang_air_herbal_drink_desc,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _widgetDetail = 2;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 27, 78, 215),
                                  Color.fromARGB(255, 81, 126, 246)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .tumpang_air_tea_drink_title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DMSans",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Container(
                                child: Expanded(
                                    child: AutoSizeText(
                                  AppLocalizations.of(context)!
                                      .tumpang_air_tea_drink_desc,
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _widgetDetail = 3;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 120, 212, 255),
                                  Color.fromARGB(255, 94, 190, 240)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .tumpang_air_wound_title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DMSans",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Container(
                                child: Expanded(
                                    child: AutoSizeText(
                                  AppLocalizations.of(context)!
                                      .tumpang_air_wound_desc,
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
            color: Colors.white,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Text("Benefit",
                style: TextStyle(
                    fontFamily: "DMSans",
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
        Container(
          width: MediaQuery.of(context).size.width,
          height:
              MediaQuery.sizeOf(context).width * 0.7, // Tinggi yang diinginkan
          decoration: BoxDecoration(color: Colors.white),
          child: PageView.builder(
            itemCount: TumpangAirList.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final plant = TumpangAirList[index];
              var _scale = index == _currentPage ? 1.0 : 0.9;
              return TweenAnimationBuilder(
                  tween: Tween(begin: _scale, end: _scale),
                  duration: Duration(milliseconds: 350),
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      decoration: _getDecoration(index),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${plant.id}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: "DMSans",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.05,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    getLocalizedTextTitle(context, plant.title),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "DMSans",
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.07,
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  getLocalizedTextDescription(
                                      context, plant.description),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 1.5),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  });
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  TumpangAirList.length,
                  (index) =>
                      Indicator(isActive: _currentPage == index ? true : false))
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.1),
          color: Colors.white,
          child: Text(
            AppLocalizations.of(context)!.herbal_location,
            style: TextStyle(
                fontFamily: "DMSans",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.1),
          color: Colors.white,
          child: Text(
            AppLocalizations.of(context)!.herbal_location2,
            style: TextStyle(
                fontFamily: "DMSans",
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                  initialCenter:
                      _currentLocation ?? LatLng(-8.1706070, 113.7229250),
                  initialZoom: 10.0,
                  minZoom: 3,
                  maxZoom: 20,
                  onTap: (_, __) => _popupLayerController.hideAllPopups()),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers:
                        plantMarkers.map((e) => e['marker'] as Marker).toList(),
                    popupController: _popupLayerController,
                    markerTapBehavior:
                        MarkerTapBehavior.togglePopupAndHideRest(),
                    popupDisplayOptions: PopupDisplayOptions(
                        builder: (BuildContext context, Marker marker) {
                      final match = plantMarkers.firstWhere(
                        (e) => e['marker'].key == marker.key,
                        orElse: () => {'name': 'None'},
                      );
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              getLocalizedPlantName(context, match["name"])),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget widgetPrepHerbal() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "1",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_1,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "2",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_2,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "3",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_3,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "4",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_4,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "5",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_5,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "6",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_herbal_drink_6,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _widgetDetail = -1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 79, 117, 217),
                      Color.fromARGB(255, 38, 88, 222)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
              child: Text(
                AppLocalizations.of(context)!.back,
                style: TextStyle(
                  fontFamily: "DMSans",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget widgetPrepTea() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "1",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_tea_drink_1,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "2",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_tea_drink_2,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "3",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_tea_drink_3,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "4",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_tea_drink_4,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "5",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_tea_drink_5,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _widgetDetail = -1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 79, 117, 217),
                      Color.fromARGB(255, 38, 88, 222)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
              child: Text(
                AppLocalizations.of(context)!.back,
                style: TextStyle(
                  fontFamily: "DMSans",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget widgetPrepWound() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "1",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_wound_1,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 69, 200),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "2",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_wound_2,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 59, 99, 203),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Pastikan sejajar di atas
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "3",
                    style: TextStyle(
                        color: Color.fromARGB(255, 20, 69, 200),
                        fontFamily: "DMSans",
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ), // Bisa dihapus jika tidak diperlukan
                Expanded(
                  // Biarkan teks menyesuaikan ruang
                  child: Text(
                    AppLocalizations.of(context)!.tumpang_air_wound_3,
                    style: TextStyle(
                        fontFamily: "DMSans",
                        fontSize: 14,
                        color: Colors.white),
                    softWrap: true, // Aktifkan wrap otomatis
                    overflow:
                        TextOverflow.visible, // Pastikan teks tetap terlihat
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _widgetDetail = -1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 79, 117, 217),
                      Color.fromARGB(255, 38, 88, 222)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
              child: Text(
                AppLocalizations.of(context)!.back,
                style: TextStyle(
                  fontFamily: "DMSans",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
