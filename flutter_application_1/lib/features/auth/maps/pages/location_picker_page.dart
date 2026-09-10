import 'package:flutter/material.dart';

import '../models/location_model.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    this.initialAddress = '',
    this.initialLatitude = 0,
    this.initialLongitude = 0,
  });

  final String initialAddress;
  final double initialLatitude;
  final double initialLongitude;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late final TextEditingController addressController;
  late final TextEditingController latitudeController;
  late final TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.initialAddress);
    latitudeController = TextEditingController(
      text:
          widget.initialLatitude == 0 ? '' : widget.initialLatitude.toString(),
    );
    longitudeController = TextEditingController(
      text: widget.initialLongitude == 0
          ? ''
          : widget.initialLongitude.toString(),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Location',
          style: TextStyle(
            color: Color(0xFF1B2334),
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery location',
              style: TextStyle(
                color: Color(0xFF1B2334),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: latitudeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: longitudeController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final address = addressController.text.trim();
                  final latitude =
                      double.tryParse(latitudeController.text.trim()) ?? 0;
                  final longitude =
                      double.tryParse(longitudeController.text.trim()) ?? 0;

                  if (address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address is required'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final location = LocationModel(
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                  );

                  Navigator.pop(context, location);
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text('Confirm Location'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6047FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
