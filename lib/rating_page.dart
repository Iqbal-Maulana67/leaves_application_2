import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<StatefulWidget> createState() => _RatingPage();
}

class _RatingPage extends State<RatingPage> {
  int _selectedRate = 0;
  TextEditingController emailController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void sendRating(BuildContext context) async {
    if (emailController.text.isEmpty ||
        feedbackController.text.isEmpty ||
        _selectedRate == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please select your rate 1-5, input your email and feedback')),
      );
    } else {
      var uri =
          Uri.parse("https://fa6f-66-96-225-189.ngrok-free.app/api/send-rate/");
      var request = http.MultipartRequest('POST', uri)
        ..fields.addAll({
          'rates': _selectedRate.toString(),
          'email': emailController.text,
          'feedback': feedbackController.text,
        });

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your feedback has been sent.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error please try again next time')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 20, 69, 200)),
          width: MediaQuery.sizeOf(context).width,
          // height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
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
                padding: EdgeInsets.only(
                    left: 10, top: MediaQuery.sizeOf(context).height * 0.05),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/icon_rate.png",
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
                      AppLocalizations.of(context)!.feedback_title,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: "DMSans",
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.feedback_desc,
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
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.1),
                      child: Row(
                        children: [
                          _rateOptions(Color.fromRGBO(240, 89, 48, 1), 1,
                              'assets/images/rate1.png'),
                          _rateOptions(Color.fromRGBO(245, 146, 75, 1), 2,
                              'assets/images/rate2.png'),
                          _rateOptions(Color.fromRGBO(255, 201, 0, 1), 3,
                              'assets/images/rate3.png'),
                          _rateOptions(Color.fromRGBO(168, 212, 0, 1), 4,
                              'assets/images/rate4.png'),
                          _rateOptions(Color.fromRGBO(90, 191, 0, 1), 5,
                              'assets/images/rate5.png')
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.1),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior
                              .never, // Supaya label tidak naik ke atas garis
                          alignLabelWithHint:
                              true, // Membuat label tetap di atas
                          hintText: "Email",
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10,
                              10), // Mengatur padding agar teks di kiri atas
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          isDense: true, // Mengurangi ukuran tinggi input
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * 0.1),
                      child: TextField(
                        controller: feedbackController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Feedback',
                          floatingLabelBehavior: FloatingLabelBehavior
                              .never, // Supaya label tidak naik ke atas garis
                          alignLabelWithHint:
                              true, // Membuat label tetap di atas
                          hintText: AppLocalizations.of(context)!.feedback,
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10,
                              10), // Mengatur padding agar teks di kiri atas
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          isDense: true, // Mengurangi ukuran tinggi input
                        ),
                        maxLines: 5,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.sizeOf(context).width * 0.1,
                          top: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              sendRating(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
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
                                "Submit",
                                style: TextStyle(
                                  fontFamily: "DMSans",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
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
                                AppLocalizations.of(context)!.cancel,
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rateOptions(Color color, int value, String imgPath) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedRate = value;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: MediaQuery.sizeOf(context).width * 0.1,
          height: MediaQuery.sizeOf(context).width * 0.1,
          decoration: BoxDecoration(
              border:
                  Border.all(color: color, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(40),
              color: _selectedRate == value ? color : Colors.white),
          child: Image.asset(imgPath),
        ));
  }
}
