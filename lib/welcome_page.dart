import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/languages_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<StatefulWidget> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  // bool _startAnimation = false;
  // bool _showLanguage = false;
  // String? _selectedLanaguage;

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
          decoration: BoxDecoration(color: Color.fromRGBO(20, 69, 200, 1)),
          height: MediaQuery.sizeOf(context).height * 1,
          width: MediaQuery.sizeOf(context).width * 1,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.sizeOf(context).height * 0.9,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.1,
                      left: MediaQuery.sizeOf(context).width * 0.3,
                      child: Image.asset(
                        "assets/images/doctor.png",
                        height: MediaQuery.sizeOf(context).height * 0.5,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height * 0.5,
                      left: MediaQuery.sizeOf(context).width * 0.08,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/bg_welcome.png"),
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                        )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Welcome To",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "DMSans",
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "Herba Class",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "DMSans",
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Classification of Wild Plants as Medical Plants",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "DMSans",
                                  fontSize: 16,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LanguagesPage()));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Start Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "DMSans",
                            fontSize: 14,
                            color: Color.fromARGB(255, 20, 69, 200)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
