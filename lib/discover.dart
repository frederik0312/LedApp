import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';

const String discovery_service = "_http._tcp";

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => new _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  FlutterMdnsPlugin _mdnsPlugin;
  List<String> messageLog = <String>[];
  DiscoveryCallbacks discoveryCallbacks;
  List<ServiceInfo> _discoveredServices = <ServiceInfo>[];
  List<String> _ips = <String>[];
  List<RaisedButton> buttonsList = new List<RaisedButton>();

  @override
  initState() {
    super.initState();

    discoveryCallbacks = new DiscoveryCallbacks(
      onDiscovered: (ServiceInfo info) {
        print("Discovered ${info.toString()}");
        setState(() {
          messageLog.insert(0, "DISCOVERY: Discovered ${info.toString()}");
        });
      },
      onDiscoveryStarted: () {
        print("Discovery started");
        setState(() {
          messageLog.insert(0, "DISCOVERY: Discovery Running");
        });
      },
      onDiscoveryStopped: () {
        print("Discovery stopped");
        setState(() {
          messageLog.insert(0, "DISCOVERY: Discovery Not Running");
        });
      },
      onResolved: (ServiceInfo info) {
        print("Resolved Service ${info.toString()}");
        setState(() {
          messageLog.insert(0, "DISCOVERY: Resolved ${info.toString()}");
          _ips.insert(_ips.length, info.address.toString());
        });
      },
    );

    messageLog.add("Starting mDNS for service [$discovery_service]");
    startMdnsDiscovery(discovery_service);
  }

  startMdnsDiscovery(String serviceType) {
    _mdnsPlugin = new FlutterMdnsPlugin(discoveryCallbacks: discoveryCallbacks);
    // cannot directly start discovery, have to wait for ios to be ready first...
    Timer(Duration(seconds: 3), () => _mdnsPlugin.startDiscovery(serviceType));
//    mdns.startDiscovery(serviceType);
  }

  void reassemble() {
    super.reassemble();

    if (null != _mdnsPlugin) {
      _discoveredServices = <ServiceInfo>[];
      _ips = <String>[];
      _mdnsPlugin.restartDiscovery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          body: Column(
        children: [
          Wrap(
            children: _buildDeviceList(),
            direction: Axis.vertical,
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messageLog.length,
              itemBuilder: (BuildContext context, int index) {
                return new Text(messageLog[index]);
              },
            ),
          ),
        ],
      )),
    );
  }

  List<Widget> _buildDeviceList() {
    for (int i = 0; i < _ips.length; i++) {
      buttonsList.add(new RaisedButton(onPressed: null, child: Text(_ips[i])));
    }
    return buttonsList;
  }
}
