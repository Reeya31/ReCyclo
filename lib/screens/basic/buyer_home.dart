import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BuyerHome(),
    );
  }
}

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
   late GoogleMapController _googleMapController;
  late Marker _userMarker;

  @override
  void initState() {
    super.initState();
    _userMarker = Marker(markerId: const MarkerId('userLocation'));
    _requestPermissionAndGetCurrentLocation();
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
      body: 
      GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 14),
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        markers: {_userMarker},
        onTap: _handleTap,
      ),
    );
  }

  Future<void> _requestPermissionAndGetCurrentLocation() async {
  var status = await Permission.location.request();
  if (status == PermissionStatus.granted) {
    _getCurrentLocation();
  } else {
    print('Location permission denied');
  }
}


  Future<void> _getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Current Location: ${position.latitude}, ${position.longitude}');
    _updateMarkerPosition(LatLng(position.latitude, position.longitude));
  } catch (e) {
    print('Error fetching location: $e');
  }
}


  void _updateMarkerPosition(LatLng newPosition) {
    setState(() {
      _userMarker = _userMarker.copyWith(
        positionParam: newPosition,
        infoWindowParam: InfoWindow(title: 'Your Location'),
      );
      _googleMapController.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  void _handleTap(LatLng tapPosition) {
    _updateMarkerPosition(tapPosition);
  }
}