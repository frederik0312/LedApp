library ledapp.globals;

import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Timer _debounce;
bool done = false;
double currentSliderValue = 20;
Color currentColor = Colors.blue;
String currentIp = "";

Future<http.Response> api(String parameter) async {
  done = false;

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
      done = true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
    }
  });
}
