import 'package:ace_routes/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LatLng? targetLocation;

  const MapScreen({super.key, this.targetLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _startLocation = LatLng(41.500000, -100.000000);


  LatLng? _currentLocation;

  Set<Marker> markers = {};
  final locationMapController = Get.put(MapControllers());

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.targetLocation;
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    // Wait for FetchAllOrderLocation to complete, then call AllOrders
    await locationMapController.FetchAllOrderLocation();
    AllOrders();
  }

  void AllOrders() {
    // Dynamically create markers after the data is fetched
    for (var data in locationMapController.orders) {
      String location = data.geo;
      String address = data.address;
      String customerName = data.cnm;

      // Parse the location string to latitude and longitude
      final locationParts = location.split(',');
      double? latitude = double.tryParse(locationParts[0]);
      double? longitude = double.tryParse(locationParts[1]);

      if (latitude != null && longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId('marker_${customerName}'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: "${customerName}",
              snippet: address,
            ),
          ),
        );
      }
    }

    // Trigger a UI rebuild to display the markers
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (locationMapController.orderLocations.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _startLocation,
            zoom: 3.0,
          ),
          markers: markers,
        );
      }),
    );
  }
}
