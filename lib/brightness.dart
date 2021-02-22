import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class Brightness extends StatefulWidget {
  @override
  _BrightnessState createState() => _BrightnessState();
}

class _BrightnessState extends State<Brightness>
    with AutomaticKeepAliveClientMixin<Brightness> {
  Timer _debounce;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    Color _currentColor = globals.currentColor;
    double _currentSliderValue = globals.currentSliderValue;
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*
                    RaisedButton(
                      onPressed: () => api("T=1"),
                      child: Text("on"),
                    ),
                    RaisedButton(
                        onPressed: () => api("T=0"), child: Text("off")),
                    RaisedButton(
                        onPressed: () => api("&A=128&&FX=90"),
                        child: Text("Firework")),
                    RaisedButton(
                        onPressed: () => api("&A=128&&FX=0"),
                        child: Text("solid")),*/
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Stack(children: [
                      RotatedBox(
                        quarterTurns: -1,
                        child: Container(
                          width: 500,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 200,
                            ),
                            child: Slider(
                              activeColor: _currentColor,
                              inactiveColor: Color.fromARGB(255, 31, 64, 104),
                              value: _currentSliderValue,
                              min: 0,
                              max: 200,
                              divisions: 100,
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
                                  globals.currentSliderValue =
                                      _currentSliderValue;
                                  api("&A=" + value.toString());
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150.0),
                            child: Icon(
                              Icons.wb_sunny_outlined,
                              color: Colors.white,
                              size: 50,
                            ),
                          ))
                    ]),
                  ),
                ]),
          ),
        ],
      ),
    );
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

  @override
  bool get wantKeepAlive => true;
}
