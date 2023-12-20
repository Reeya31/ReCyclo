import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wastehub/screens/basic/feedback.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
    late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation')); // Declare userMarker variable
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    userMarker = Marker(markerId: const MarkerId('currentLocation'));
     _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 247, 245, 245)),
        title: const Text(
          "Recyclo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 149, 128),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'history_screen'); // Replace with the actual name of your history screen
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'account_screen');
            },
            icon: const Icon(
              Icons.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 2),
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        onTap: (LatLng latLng) {
          _addOrUpdateMarker(latLng);
        },
      ),

//  floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           // Fetch location on button press
//           _getCurrentLocation();
//         },
//         label: const Text("Current Location"),
//         icon: const Icon(Icons.location_history),
//       ),
    );
  }

Future<void> _getCurrentLocation() async {
  try {
    Position position = await _determinePosition();

    setState(() {
      userMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        draggable: true,
        onDragEnd: (newPosition) {
          _getPlaceName(newPosition);
        },
      );
      markers.clear();
      markers.add(userMarker);
    });
  } catch (e) {
    print("Error fetching location: $e");
  }
}


  Future<void> _getPlaceName(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print("Place Name: ${place.name}"); // Display place name in console
        // You can show place name in UI or handle it as required
      }
    } catch (e) {
      print("Error fetching place name: $e");
    }
  }

  void _addOrUpdateMarker(LatLng latLng) {
    setState(() {
      markers.remove(userMarker);
      userMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng,
        draggable: true,
        onDragEnd: (newPosition) {
          _getPlaceName(newPosition);
        },
      );
      markers.add(userMarker);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

}