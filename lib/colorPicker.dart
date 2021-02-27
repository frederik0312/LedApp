import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

import 'globals.dart' as globals;

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker>
    with AutomaticKeepAliveClientMixin<ColorPicker> {
  Color _currentColor = globals.currentColor;

  bool primary = true;
  Color primaryColor = Colors.grey;
  Color secoundColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                primary = true;
                secoundColor = _currentColor;
                print("primary");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 60,
                  height: 60,
                  color: primary ? _currentColor : primaryColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                primary = false;
                primaryColor = _currentColor;
                print("secoundary");
              },
              child: Container(
                width: 60,
                height: 60,
                color: !primary ? _currentColor : secoundColor,
              ),
            )
          ],
        ),
        Container(
          child: CircleColorPicker(
            initialColor: primary ? primaryColor : secoundColor,
            onChanged: _onColorChanged,
            colorCodeBuilder: (context, color) {
              return Container();
            },
          ),
        ),
        RaisedButton(
          onPressed: () {
            _bottomSheetMore(context);
          },
          child: Text("Patterns"),
        )
      ],
    );
  }

  void _onColorChanged(Color color) {
    if (primary) {
      setState(() {
        _currentColor = color;
        globals.currentColor = _currentColor;
      });
      globals.api("&R=" +
          _currentColor.red.toString() +
          "&G=" +
          _currentColor.green.toString() +
          "&B=" +
          _currentColor.blue.toString());
    } else {
      setState(() {
        _currentColor = color;
        globals.currentColor = _currentColor;
      });
      globals.api("&R2=" +
          _currentColor.red.toString() +
          "&G2=" +
          _currentColor.green.toString() +
          "&B2=" +
          _currentColor.blue.toString());
    }
  }

  @override
  bool get wantKeepAlive => true;
}

Widget FxTile(String title, String fxCode) {
  return Column(
    children: [
      ListTile(
        trailing: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: new Container(
            width: 6.0,
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
        onTap: () => globals.api("&A=128&&FX=" + fxCode),
        title: Center(
          child: Text(
            title,
            style: TextStyle(),
          ),
        ),
      ),
      Divider(),
    ],
  );
}

void _bottomSheetMore(context) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return new Container(
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
          top: 5.0,
          bottom: 5.0,
        ),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: new Wrap(
          children: <Widget>[
            FxTile("Firework 2d", "90"),
            FxTile("Solid", "0"),
            FxTile("Blink", "1"),
          ],
        ),
      );
    },
  );
}
