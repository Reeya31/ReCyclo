import 'dart:async';
// import 'dart:html';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SellRequest extends StatefulWidget {
  const SellRequest({super.key});

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

Marker(markerId: MarkerId('1'),
draggable: true,
position: LatLng(27.67371925729866, 85.33862832524214),
infoWindow: InfoWindow(
  title:'My Position'
)
)
];

 @override
 void initState(){
  super.initState();
  _marker.addAll(_list);
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_marker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    ),
    // floatingActionButton: FloatingActionButton(
    //   child: Icon(Icons.location_disabled_outlined)
    //   ,onPressed: ()async{
    //     GoogleMapController controller = await _controller.future;
    //     controller.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(
    //         target: LatLng(27.679392415843097, 85.33120771996676),
    //         zoom: 14
    //       )
    //       ));
    //       setState(() {
            
    //       });
    //   },
    //   ),
    );
  }
}