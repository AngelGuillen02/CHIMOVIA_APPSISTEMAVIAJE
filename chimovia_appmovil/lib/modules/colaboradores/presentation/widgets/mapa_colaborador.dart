import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapScreen extends StatefulWidget {
  final Function(LatLng, String)? onLocationSelected; 

  const OpenStreetMapScreen({Key? key, this.onLocationSelected}) : super(key: key);

  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedPoint;
  String? _selectedAddress;

  void _onTap(LatLng latLng) async {
    setState(() {
      _selectedPoint = latLng;
    });

    final address = await _reverseGeocode(latLng);
    setState(() {
      _selectedAddress = address;
    });

    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(latLng, address);
    }
  }

  Future<String> _reverseGeocode(LatLng point) async {

    return "Lat: ${point.latitude.toStringAsFixed(6)}, Lng: ${point.longitude.toStringAsFixed(6)}";
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(15.5000, -88.0333), 
              initialZoom: 8,
              onTap: (_, latLng) => _onTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              if (_selectedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedPoint!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _zoomIn,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _zoomOut,
                  ),
                ),
              ],
            ),
          ),
          if (_selectedPoint != null && _selectedAddress != null)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ubicación seleccionada:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_selectedAddress!),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}