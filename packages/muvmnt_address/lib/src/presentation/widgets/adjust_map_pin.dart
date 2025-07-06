import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/location/domain/entities/geo_latlng_entity.dart';
import 'package:mvmnt_cli/ui/map/map_screen.dart';

class AdjustMapPin extends StatelessWidget {

  const AdjustMapPin({super.key, required this.initialGeoPosition});
  final GeoLatLngEntity initialGeoPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Where is the location entrance',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            ),
            child: Stack(
              children: [
                MapScreen(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 12,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onPressed: () async {
                      final latlng = await context.push<GeoLatLngEntity>(
                        '/addresses/pin',
                        extra: initialGeoPosition,
                      );
                      if (latlng != null) {}
                    },
                    child: const Text('Adjust pin'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
