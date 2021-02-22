import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:LedApp/brightness.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Timer _debounce;
  bool done = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Frederiks Mega fed led app'),
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
  PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Timer _debounce;
  bool done = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _currentColor = Colors.blue;
  double _currentSliderValue = 20;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _currentSliderValue = globals.currentSliderValue;
    });
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.wb_sunny_outlined,
                size: 40,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.blur_off,
                  size: 40,
                ),
                label: ""),
          ],
          currentIndex: selectedIndex,
          fixedColor: Colors.white,
          unselectedItemColor: Color.fromARGB(105, 255, 255, 255),
          onTap: onItemTapped,
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 47),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Navn på device",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Brightness " +
                          (_currentSliderValue ~/ 2).toInt().toString() +
                          "%",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: globals.done ? Colors.green : Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                controller: _controller,
                allowImplicitScrolling: false,
                children: [
                  Center(child: Brightness()),
                  Center(
                    child: CircleColorPicker(
                      initialColor: _currentColor,
                      onChanged: _onColorChanged,
                      colorCodeBuilder: (context, color) {
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        /*
      */

        );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      _controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _currentColor = color;
      globals.currentColor = _currentColor;
    });
    api("&R=" +
        _currentColor.red.toString() +
        "&G=" +
        _currentColor.green.toString() +
        "&B=" +
        _currentColor.blue.toString());
  }

  Future<http.Response> api(String parameter) async {
    setState(() {
      globals.done = false;
    });
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await http.post(
        'http://192.168.0.190/win&' + parameter,
        headers: <String, String>{
          'Content-Type': 'application/xml; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        setState(() {
          globals.done = true;
        });
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print(response.statusCode);
      }
    });
  }
}
