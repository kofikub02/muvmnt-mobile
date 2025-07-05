import 'package:flutter/material.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/ui/map/map_screen.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/custom_bottom_navigation_bar.dart';

class AddressPinPage extends StatefulWidget {
  final GeoLatLngEntity latlng;

  const AddressPinPage({super.key, required this.latlng});

  @override
  State<AddressPinPage> createState() => _AddressPinPageState();
}

class _AddressPinPageState extends State<AddressPinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Adjust Pin'),
      bottomNavigationBar: CustomBottomNavigationBar(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(onPressed: () {}, child: Text('Save')),
        ),
      ),
      body: Stack(
        children: [
          MapScreen(),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop({'lat': 0, 'lng': 0});
              },
              child: Text('Adjust'),
            ),
          ),
        ],
      ),
    );
  }
}
