import 'dart:async';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key});

  @override
  State<BuyerHome> createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  geo.Position? currentPositionOfUser;
  final TextEditingController addressController = TextEditingController();

  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation'));
  Set<Marker> markers = {};
// Marker? sellerMarker;
  late io.Socket socket;

  late User? _user;
  late FirebaseFirestore firestore;
  bool isOnline = true;
  Marker? sellerMarker = Marker(markerId: const MarkerId('sellerLocation'));
  @override
  void initState() {
    super.initState();

    socket = io.io('http://192.168.143.178:3000', <String, dynamic>{
      'transport': ['webSocket'],
      'autoConnect': true,
    });

    socket.connect();

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

    // Listen for the pickup_request event
    socket.on('pickup_request', (data) {
      // Handle the pickup request here
      // Extract relevant information from the received data
      String sellerName = data['sellerName'];
      String sellerPhone = data['sellerPhone'];
      List<bool> wasteTypes = List<bool>.from(data['wasteTypes']);
      String wasteQuantity = data['wasteQuantity'];
      double sellerLatitude = data['laltitude'];
      double sellerLongitude = data['longitude'];

      // Update the user interface or show a notification

      print('Seller Name: $sellerName');
      print('Seller Phone: $sellerPhone');
      print('Waste Types: $wasteTypes');
      print('Waste Quantity: $wasteQuantity');
      print('Seller Location: ($sellerLatitude, $sellerLongitude)');
    });
  }


  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }


  void updateStatus() {
    try {
      if (_user != null) {
        // Update the 'status' field in the Firestore collection
        firestore.collection('buyers').doc(_user!.uid).update({
          'status': isOnline ? 'online' : 'offline',
        });
    
      }
    } catch (e) {
      print("Error updating status in database: $e");
    }
  }

  Future<void> getCurrentLocationOfUserAndFetchName() async {
    await getCurrentLocationOfUser(); // Get the current location
    getPlaceName(LatLng(
        currentPositionOfUser!.latitude, currentPositionOfUser!.longitude));
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
        'location': {
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
        },
      }, SetOptions(merge: true));
    }
  } catch (e) {
    print("Error storing location in database: $e");
  }
}

 @override
  Widget build(BuildContext context) {

    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue 
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), 
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    return WillPopScope( 
      onWillPop: showExitPopup, //call function on back button press
      child:Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 247, 245, 245)),
        title: const Text(
          "Recyclo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 149, 128),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 37, bottom: 10),
            child: LiteRollingSwitch(
              value: isOnline,
              textOn: "Online",
              textOff: "Offline",
              colorOn: Colors.green,
              colorOff: const Color.fromARGB(255, 77, 29, 25),
              iconOn: Icons.network_cell,
              iconOff: Icons.signal_wifi_off_outlined,
              onChanged: (bool value) {
                setState(() {
                  isOnline = value;
                  updateStatus();
                  // if (isOnline) {
                  //   Future.delayed(Duration(seconds: 10), () {
                  //     getMostRecentPickupRequest();
                  //   });
                  // }
                });
              },
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context,
                  'history_screen'); // Replace with the actual name of your history screen
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
      body: SafeArea(
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
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
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
    ),);
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

        String placeName =
            '${thoroughfare.isNotEmpty ? thoroughfare + ', ' : ''}$locality';

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