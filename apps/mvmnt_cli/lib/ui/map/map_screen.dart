import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Key _key = const Key('mapId#');
  String? _mapId;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  late BitmapDescriptor dropOffLocationIcon;
  late BitmapDescriptor pickUpLocationIcon;
  late BitmapDescriptor driverLocationIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    final currentState = context.read<ThemeCubit>().state;
    if (currentState.themeEntity?.themeType == ThemeType.dark) {
      _setMapId('6d6b41a2c095fab187443e3a');
    } else {
      _setMapId('6d6b41a2c095fab1d2e48616');
    }
    super.initState();
  }

  void _setMapId(String mapId) {
    setState(() {
      _mapId = mapId;
      // print('setting map id');
      // print(_mapId);

      // Change key to initialize new map instance for new mapId.
      _key = Key(_mapId ?? 'mapId#');
    });
  }

  @override
  void dispose() {
    _controller.future.then((onValue) {
      onValue.dispose();
    });
    super.dispose();
  }

  // void _onMapCreated(GoogleMapController controllerParam) {
  //   setState(() {
  //     // controller = controllerParam;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state.themeEntity == null) {
          return;
        }

        if (state.themeEntity?.themeType == ThemeType.dark) {
          _setMapId('6d6b41a2c095fab187443e3a');
        } else {
          _setMapId('6d6b41a2c095fab1d2e48616');
        }
      },
      builder: (context, state) {
        // print(_mapId);
        return GoogleMap(
          key: _key,
          cloudMapId: _mapId,
          initialCameraPosition: _kGooglePlex,
          compassEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers),
        );
      },
    );
  }
}
