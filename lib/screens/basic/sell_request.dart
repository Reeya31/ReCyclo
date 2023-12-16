import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SellRequest extends StatefulWidget {
  const SellRequest({Key? key}) : super(key: key);

  @override
  State<SellRequest> createState() => _SellRequestState();
}

class _SellRequestState extends State<SellRequest> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(27.67371925729866, 85.33862832524214),
    zoom: 14,
  );

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      draggable: true,
      position: LatLng(27.67371925729866, 85.33862832524214),
      infoWindow: InfoWindow(
        title: 'My Position',
      ),
    )
  ];

  String _selectedWasteType = 'Plastic';
  String _selectedWasteQuantity = 'Below 1kg';

  List<String> _wasteTypes = [
    'Plastic',
    'Paper',
    'Glass',
    'Metal & Steel',
    'E-Waste',
  ];

  List<String> _wasteQuantities = [
    'Below 1kg',
    '1 to 5 kg',
    'Above 5 kg',
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
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
}