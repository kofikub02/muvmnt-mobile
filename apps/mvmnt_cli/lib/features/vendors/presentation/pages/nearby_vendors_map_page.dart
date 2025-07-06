import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyVendorsMapPage extends StatefulWidget {
  static const String route = '/nearby-vendors';

  const NearbyVendorsMapPage({super.key});

  @override
  State<NearbyVendorsMapPage> createState() => _NearbyVendorsMapPageState();
}

class _NearbyVendorsMapPageState extends State<NearbyVendorsMapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};
  late BitmapDescriptor vendorIcon;
  String? _mapStyle;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void setMapStyle() {
    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            style: _mapStyle,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(markers),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.keyboard_backspace),
        onPressed: () {
          context.pop(context);
        },
      ),
    );
  }
}
