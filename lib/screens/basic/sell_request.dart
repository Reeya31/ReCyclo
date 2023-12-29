import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SellRequest extends StatefulWidget {
  const SellRequest({Key? key}) : super(key: key);

  @override
  State<SellRequest> createState() => _SellRequestState();
}

class _SellRequestState extends State<SellRequest> {
  late GoogleMapController googleMapController;
  late Marker userMarker = Marker(markerId: const MarkerId('currentLocation')); // Declare userMarker variable
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    userMarker = Marker(markerId: const MarkerId('currentLocation'));
     _getCurrentLocation();
  }

  String _selectedWasteType = 'Plastic';
  String _selectedWasteQuantity = 'Below 1kg';

  List<String> _wasteTypes = [
    'Plastic',
    'Paper',
    'Glass',
    'Metal & Steel',
    'E-Waste',
  ];

List<String> wasteType = ["Plastic", "Paper", "Glass", "Metal & Steel", "E-Waste"];
  List<bool> selectedWaste = [false, false, false, false];

  List<String> _wasteQuantities = [
    'Below 1kg',
    '1 to 5 kg',
    'Above 5 kg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(27.672468, 85.337924), zoom: 14),
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

      
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Row(
                      children: [
                        Text('Waste Type :', style: TextStyle(fontSize: 18),),
                        SizedBox(width: 12,),
                        DropdownButton<String>(
                      value: _selectedWasteType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedWasteType = newValue!;
                        });
                      },
                      items: _wasteTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                      ],
                    ),
                    
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Waste Quantity:',style: TextStyle(fontSize: 18),),
                        SizedBox(width: 12,),
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
                        // Handle send pickup request here
                        // Access selected waste type: _selectedWasteType
                        // Access selected waste quantity: _selectedW
                      },
                      child: Text('Send Pickup Request', style: TextStyle(fontSize: 15,color: Colors.white),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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