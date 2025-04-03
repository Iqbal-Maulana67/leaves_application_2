import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/camera_page.dart';
import 'package:leaves_classification_application_nimas/history_page.dart';
import 'package:leaves_classification_application_nimas/languages_page.dart';
import 'package:leaves_classification_application_nimas/languages_page2.dart';
import 'package:leaves_classification_application_nimas/rating_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.6);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      "Shah Alam",
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
                  "Hi there!\nWhat plant are you curious for today?",
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
                                    "History",
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
                                    "Feedback",
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
                                  "Language",
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
                                  "Identify",
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
                  "Plants around you right now",
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
                  child: PageView.builder(
                    itemCount: 3,
                    controller: _pageController,
                    itemBuilder: (context, index) {
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
                                    borderRadius: BorderRadius.circular(15)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 15),
                                child: Image.asset(
                                  "assets/images/icon_leaves.png",
                                  height: 30,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Plants name",
                                  style: TextStyle(
                                      fontFamily: "DMSans",
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
