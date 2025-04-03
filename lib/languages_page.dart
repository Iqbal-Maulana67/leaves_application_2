import 'package:flutter/material.dart';
import 'package:leaves_classification_application_nimas/home_page.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<StatefulWidget> createState() => _LanguagesPage();
}

class _LanguagesPage extends State<LanguagesPage> {
  String? _selectedLanguage;

  @override
  void initState() {
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
                padding: EdgeInsets.only(
                    left: 10, top: MediaQuery.sizeOf(context).height * 0.1),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/icon_lang.png",
                  height: 100,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Your Preffered Language",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Please select your language",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: "DMSans",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Image.asset("assets/images/bg_language.png"),
              ),
              Container(
                padding: EdgeInsets.only(top: 40),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _languageOption("assets/images/icon_id.png", "Indonesia"),
                    _languageOption("assets/images/icon_malay.png", "Malaysia"),
                    _languageOption("assets/images/icon_en.png", "English"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.sizeOf(context).width * 0.1,
                            top: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                          "Choose",
                          style: TextStyle(
                            fontFamily: "DMSans",
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _languageOption(String assetPath, String language) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: (_selectedLanguage == language)
                ? const Color.fromRGBO(194, 136, 248, 1)
                : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              assetPath,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10),
            Text(
              language,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: (_selectedLanguage == language)
                  ? Image.asset(
                      'assets/images/check.png',
                      width: 20,
                      height: 20,
                    )
                  : null,
            ))
          ],
        ),
      ),
    );
  }
}
