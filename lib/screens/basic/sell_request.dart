import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_google_maps_webservices/places.dart';

class SellRequest extends StatefulWidget {
  const SellRequest({Key? key}) : super(key: key);

  @override
  State<SellRequest> createState() => _SellRequestState();
}

class _SellRequestState extends State<SellRequest> {
  geo.Position? currentPositionOfUser;
  final TextEditingController addressController = TextEditingController();

  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation'));
  Set<Marker> markers = {};

   bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userMarker = Marker(markerId: const MarkerId('currentLocation'));
    getCurrentLocationOfUserAndFetchName();
    getCurrentLocation();
  }

  Future<void> getCurrentLocationOfUserAndFetchName() async {
    await getCurrentLocationOfUser(); // Get the current location
    getPlaceName(LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude));
  }

  // String _selectedWasteType = 'Plastic';
  String _selectedWasteQuantity = 'Below 1kg';

  List<String> wasteType = ["Plastic", "Paper", "Glass", "e-Waste"];
  List<bool> selectedWaste = [false, false, false, false];

  List<String> _wasteQuantities = [
    'Below 1kg',
    '1 to 5 kg',
    'Above 5 kg',
  ];

  Future<void> getCurrentLocationOfUser() async {
    geo.Position positionOfUser = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);

    currentPositionOfUser = positionOfUser;

    LatLng(currentPositionOfUser!.latitude, currentPositionOfUser!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SlidingUpPanel(
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height - 200,
          panel: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
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
                Column(
                  children: [
                    Text(
                      'Waste Type :',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                     ListView.builder(
              shrinkWrap: true,
              itemCount: wasteType.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                    title: Text(wasteType[index]),
                    value: selectedWaste[index],
                    onChanged: (value) {
                      setState(() {
                        selectedWaste[index] = value!;
                      });
                    });
              },
            ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Waste Quantity:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    DropdownButton<String>(
                      value: _selectedWasteQuantity,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedWasteQuantity = newValue!;
                        });
                      },
                      items: _wasteQuantities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
  onPressed: () {
    // Check if waste type is selected
    if (selectedWaste.contains(true)) {
      // Show finding message at the top of the page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Finding a buyer for you'),
                SizedBox(width: 10),
                CircularProgressIndicator(),
              ],
            ),
          ),
          duration: Duration(seconds: 8),
        ),
      );

      // Simulate loading for 5 seconds
      Future.delayed(Duration(seconds: 8), () {
        // Hide the previous snackbar
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        // Show message "Sorry, currently no drivers are available" at the bottom of the page
        final snackBarError = SnackBar(
          content: Text('Sorry, currently no buyers are available'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      });
    } else {
      // Show message "Please select a waste type" at the bottom of the page
      final snackBarError = SnackBar(
        content: Text('Please select a waste type'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
    }
  },
  child: Text(
    'Send Request',
    style: TextStyle(fontSize: 15, color: Colors.white),
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