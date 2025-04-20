import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/models/tumpangAirList.dart';
import 'package:leaves_classification_application_nimas/widgets/indicator.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';

class TumpangAirResult extends StatefulWidget {
  final double accuracy;

  const TumpangAirResult({super.key, required this.accuracy});

  @override
  State<StatefulWidget> createState() => _TumpangAirResult();
}

class _TumpangAirResult extends State<TumpangAirResult> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  int _currentPage = 0;
  int _widgetDetail = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg_result.png"),
                      fit: BoxFit.contain)),
              width: MediaQuery.sizeOf(context).width,
              height: 300,
              child: SizedBox(
                child: Image.asset("assets/images/leaves_pegagan.png"),
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
                      valueNotifier: ValueNotifier(20),
                      onGetText: (double value) {
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
              child: _widgetDetail > 0 ? widgetPrep() : widgetPrep2(),
            )
          ],
        )),
      ),
    );
  }

  Widget widgetPrep() {
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
                    "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
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
                    "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
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
                    "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
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
                    "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
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
                _widgetDetail = 0;
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
                "Back",
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

  Widget widgetPrep2() {
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
                            "Herbal\nDrink\nPreparation",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "DMSans",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
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
                            _widgetDetail = 1;
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
                                "Tea Preparation",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DMSans",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Text(
                                "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
                                style: TextStyle(color: Colors.white),
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
                            _widgetDetail = 1;
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
                                "Wound Treatment",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DMSans",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                              Text(
                                "Lorem ipsum dolor sit amet. Aut facere similique ut impedit iure ab praesentium",
                                style: TextStyle(color: Colors.white),
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
            "Herbal Plant Location",
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
            "Find the Wild Plant Habitat You Seek",
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
              options: MapOptions(
                initialCenter: LatLng(-6.1751, 106.8650), // Koordinat Jakarta
                initialZoom: 10.0,
                minZoom: 3, // Tambahkan batasan minimal
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
