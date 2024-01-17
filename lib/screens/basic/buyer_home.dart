import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ReCyclo/screens/basic/feedback.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _HomeState();
}

class _HomeState extends State<BuyerHome> {
geo.Position? currentPositionOfUser;
  final TextEditingController addressController = TextEditingController();

  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation'));
  Set<Marker> markers = {};
 
 late User? _user;
  late FirebaseFirestore firestore;

 @override
  void initState() {
    super.initState();

     FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
    // Initialize Firebase
    Firebase.initializeApp().then((value) {
      firestore = FirebaseFirestore.instance;
      getCurrentLocationOfUserAndFetchName();
      getCurrentLocation();
    });
  }

 Future<void> getCurrentLocationOfUserAndFetchName() async {
    await getCurrentLocationOfUser(); // Get the current location
    getPlaceName(LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude));
  }


Future<void> getCurrentLocationOfUser() async {
    geo.Position positionOfUser = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);

    currentPositionOfUser = positionOfUser;

    LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  }

Future<void> storeLocationInDatabase(LatLng latLng) async {
  try {
    if (_user != null) {
      await firestore.collection('buyers').doc(_user!.uid).set({
        // 'latitude': latLng.latitude,
        // 'longitude': latLng.longitude,
        'location': GeoPoint(latLng.latitude, latLng.longitude),
      },SetOptions(merge: true));
    }
  } catch (e) {
    print("Error storing location in database: $e");
  }
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
SafeArea(
        child: SlidingUpPanel(
          minHeight: 50,
          maxHeight: MediaQuery.of(context).size.height - 740,
          panel: Container(
            // padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 8),
                    height: 5,
                    width: 100,
                    decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: addressController,
                  readOnly: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
          ),
          body: GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(27.672468, 85.337924), zoom: 14),
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
           onTap: (LatLng latLng) {
            addOrUpdateMarker(latLng);
            getPlaceName(latLng);
            storeLocationInDatabase(latLng); // Store location when tapped
          },
          ),
        ),
      ),

    );
  }


   Future<void> getCurrentLocation() async {
    try {
      geo.Position position = await determinePosition();

      setState(() {
        userMarker = Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          draggable: true,
          onDragEnd: (newPosition) {
            getPlaceName(newPosition);
          },
        );
        markers.clear();
        markers.add(userMarker);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> getPlaceName(LatLng position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en_US');

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      String thoroughfare = place.thoroughfare ?? '';
      String locality = place.locality ?? '';

      String placeName = '${thoroughfare.isNotEmpty ? thoroughfare + ', ' : ''}$locality';

      print("Place Name: $placeName");
      // You can show place name in UI or handle it as required
      setState(() {
        addressController.text = placeName;
      });
    }
  } catch (e) {
    print("Error fetching place name: $e");
  }
}

  void addOrUpdateMarker(LatLng latLng) {
    setState(() {
      markers.remove(userMarker);
      userMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: latLng,
        draggable: true,
        onDragEnd: (newPosition) {
          getPlaceName(newPosition);
        },
      );
      markers.add(userMarker);
    });
  }

  Future<geo.Position> determinePosition() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();

      if (permission == geo.LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition();

    return position;
  }

}