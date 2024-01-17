import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_google_maps_webservices/places.dart';

class FindingBuyerAnimation extends StatefulWidget {
  @override
  _FindingBuyerAnimationState createState() => _FindingBuyerAnimationState();
}

class _FindingBuyerAnimationState extends State<FindingBuyerAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14,
              // origin: Offset(50.0, 50.0),
              child: Center(
                child: Icon(
                  Icons.circle_outlined,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
        Text("Searching for Buyers",style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.white))
      ],
    );
  }
}


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
  PanelController _pc = new PanelController();

  bool isLoading = false;

  List<String> wasteType = ["Plastic", "Paper", "Glass", "e-Waste"];
  List<bool> selectedWaste = [false, false, false, false];

 bool showFindingBuyerAnimation = false; 

  String? buyerName;
  String? buyerPhone;
  String? buyerPlaceName;
  String? placeName; 

  LatLng? selectedBuyerLocation;
  double? buyerLat;
  double? buyerLon;

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

  bool findingBuyer = false;

// Function to fetch buyer information based on the KNN algorithm
Future<void> findRelevantBuyer(List<bool> sellerWasteTypes, String sellerWasteQuantity,
    LatLng sellerLocation) async {
  try {
    setState(() {
      isLoading = false;
      showFindingBuyerAnimation = true;
    });

    await Future.delayed(Duration(seconds: 5)); // Simulate loading

    QuerySnapshot buyersSnapshot = await FirebaseFirestore.instance.collection('buyers').get();

    String? selectedBuyerFullName;
    String? selectedBuyerPhone;
    String? selectedBuyerPlaceName;
    double? minDistance;
    LatLng? selectedBuyerLocation;

    for (QueryDocumentSnapshot buyerSnapshot in buyersSnapshot.docs) {
  Map<String, dynamic> buyerData = buyerSnapshot.data() as Map<String, dynamic>;

  String buyerFullName = buyerData['fullname'] ?? '';
  String buyerPhone = buyerData['phone'] ?? '';
  String buyerPlaceName = buyerData['PlaceName'] ?? '';
  List<bool> buyerWasteTypes = List<bool>.from(buyerData['WasteType']);
  String buyerWasteQuantity = buyerData['WasteQuantity'] ?? '';
  GeoPoint buyerLocation = buyerData['location'];
  double buyerLat = buyerLocation.latitude;
  double buyerLon = buyerLocation.longitude;

  List<String> buyerWasteTypeObjects = buyerWasteTypes
      .asMap()
      .entries
      .where((entry) => entry.value)
      .map((entry) => wasteType[entry.key])
      .toList();

  if (sellerWasteTypes.asMap().entries.any((entry) =>
      entry.value && buyerWasteTypeObjects.contains(wasteType[entry.key]))) {
    if (sellerWasteQuantity == buyerWasteQuantity) {
      double distance = calculateDistance(
          sellerLocation.latitude, sellerLocation.longitude, buyerLat, buyerLon);

      if (minDistance == null || distance < minDistance) {
        minDistance = distance;
        selectedBuyerFullName = buyerFullName;
        selectedBuyerPhone = buyerPhone;
        selectedBuyerPlaceName = buyerPlaceName;
        selectedBuyerLocation = LatLng(buyerLat, buyerLon);
      }
    }
  }
}

    
if (selectedBuyerFullName != null) {
  // Set buyer information
  setState(() {
    buyerName = selectedBuyerFullName;
    buyerPhone = selectedBuyerPhone;
    buyerPlaceName = selectedBuyerPlaceName;
    buyerLat = buyerLat;  // <-- No need to update buyerLat and buyerLon again
    buyerLon = buyerLon;
    selectedBuyerLocation = LatLng(buyerLat!, buyerLon!); 
  });

  // Add the buyer's location to the markers
  setState(() {
    markers.add(Marker(
      markerId: MarkerId('selectedBuyer'),
      position: selectedBuyerLocation!,
    ));
  });

      // Display message to the seller
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$selectedBuyerFullName has been appointed to you.\n'
              'Phone: $selectedBuyerPhone\nPlace Name: $selectedBuyerPlaceName'),
        ),
      );

      // Update the UI or perform any other actions as needed
      print('Selected Buyer Full Name: $selectedBuyerFullName');
      print('Selected Buyer Phone: $selectedBuyerPhone');
      print('Selected Buyer Place Name: $selectedBuyerPlaceName');
    } else {
      // No relevant buyer found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No buyers are available.'),
        ),
      );
    }
  } catch (e) {
    print('Error finding relevant buyer: $e');
  } finally {
    setState(() {
      isLoading = false;
      showFindingBuyerAnimation = false;
    });
  }
}


// Method for calculating distance (Haversine formula)
double calculateDistance(double startLat, double startLon, double endLat, double endLon) {
    const double earthRadius = 6371.0; // Earth radius in kilometers

    // Convert degrees to radians
    double toRadians(double degree) {
      return degree * (pi / 180.0);
    }

    // Haversine formula
    num haversine(double theta) {
      return pow(sin(theta / 2), 2);
    }

    double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
      double dLat = toRadians(lat2 - lat1);
      double dLon = toRadians(lon2 - lon1);

      double a = haversine(dLat) + cos(toRadians(lat1)) * cos(toRadians(lat2)) * haversine(dLon);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      return earthRadius * c;
    }

    return haversineDistance(startLat, startLon, endLat, endLon);
  }


Future<void> sendPickupRequest() async {
    try {
      // Get the selected waste type and quantity
      List<String> selectedWasteTypes = wasteType
          .asMap()
          .entries
          .where((entry) => selectedWaste[entry.key])
          .map((entry) => entry.value)
          .toList();


      String wasteQuantity = _selectedWasteQuantity;

      // Get the current location details
      String placeName = addressController.text;
      LatLng currentLocation = userMarker.position;

      if (selectedWasteTypes.isNotEmpty) {
        // Construct the pickup request data with an array of boolean values for waste types
        Map<String, dynamic> pickupRequestData = {
          'WasteType': selectedWaste,
          'WasteQuantity': wasteQuantity,
          'PlaceName': placeName,
          'location': GeoPoint(currentLocation.latitude, currentLocation.longitude),
        };

        // Send the pickup request to Firestore
        await FirebaseFirestore.instance.collection('pickupRequests').add(pickupRequestData);
        // Collapse the sliding panel after sending the request
        _pc.close();
        // Show a success message or navigate to a confirmation screen
        print('Pickup request sent successfully!');

        // Find the most relevant buyer
        await findRelevantBuyer(
            selectedWaste, _selectedWasteQuantity, currentLocation);
      } else {
        // Show message "Please select a waste type" at the bottom of the page
        final snackBarError = SnackBar(
          content: Text('Please select a waste type'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      }
    } catch (e) {
      print('Error sending pickup request: $e');
      // Handle the error (show an error message, etc.)
    }
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
                    // Check if at least one waste type is selected
                    if (selectedWaste.any((waste) => waste)) {
                      sendPickupRequest();
                    } else {
                      // Show message "Please select a waste type" at the bottom of the page
                      final snackBarError = SnackBar(
                        content: Text('Please select at least one waste type'),
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
          controller: _pc, 
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: LatLng(27.672468, 85.337924), zoom: 14),
                // markers: markers,
                markers: markers..addAll(selectedBuyerLocation != null
                    ? [Marker(markerId: const MarkerId('selectedBuyer'), position: selectedBuyerLocation!)]
                    : []),

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
               if (showFindingBuyerAnimation || isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FindingBuyerAnimation(),
                          SizedBox(height: 16),
    
                          if (isLoading) CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isLoading && buyerName != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.green, // Set the background color to green
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buyer Information', style: TextStyle(fontSize: 18, color: Colors.white)), // Set the font color to white
                      SizedBox(height: 8),
                      Text('Name: $buyerName', style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Phone: $buyerPhone', style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Place Name: $buyerPlaceName', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
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