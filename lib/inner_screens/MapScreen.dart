/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Location _location = Location();
  late LatLng _currentLocation;
  late List<Marker> _tiendasMarkers;
  late List<Marker> _hotelesMarkers;
  late List<Marker> _hospitalesMarkers;
  bool _showTiendas = false;
  bool _showHoteles = false;
  bool _showHospitales = false;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    _currentLocation = await _getLocation();
    _tiendasMarkers = await _getTiendasMarkers();
    _hotelesMarkers = await _getHotelesMarkers();
    _hospitalesMarkers = await _getHospitalesMarkers();
    setState(() {
      // Actualizar el estado después de cargar los marcadores
      _showSnackbar("¡Los marcadores se cargaron exitosamente!");
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<LatLng> _getLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      print("Error getting location: $e");
      return LatLng(0.0, 0.0); // Otra ubicación predeterminada
    }
  }

  Future<List<Marker>> _getTiendasMarkers() async {
    List<Marker> tiendasMarkers = [
      Marker(
        markerId: MarkerId('tiendaRopa1'),
        position: LatLng(-8.1076, -79.0300), // Coordenas de la Tienda 1
        infoWindow: InfoWindow(title: 'Boutique Lola Bunny'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/tienda.png',
        ),
      ),
      Marker(
        markerId: MarkerId('tiendaRopa2'),
        position: LatLng(-8.1185, -79.0229), // Coordenas de la Tienda 2
        infoWindow: InfoWindow(title: 'Tiendas Él'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/tienda.png',
        ),
      ),
      // Puedes añadir más tiendas según sea necesario
    ];

    return tiendasMarkers;
  }

  Future<List<Marker>> _getHotelesMarkers() async {
    List<Marker> hotelesMarkers = [
      Marker(
        markerId: MarkerId('hotel1'),
        position: LatLng(-8.1027, -79.0293), // Coordenas del Hotel 1
        infoWindow: InfoWindow(title: 'Hotel San Isidro'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hotel.png',
        ),
      ),
      Marker(
        markerId: MarkerId('hotel2'),
        position: LatLng(-8.1187, -79.0427), // Coordenas del Hotel 2
        infoWindow: InfoWindow(title: 'Hostal Olimpo'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hotel.png',
        ),
      ),
      // Puedes añadir más hoteles según sea necesario
    ];

    return hotelesMarkers;
  }

  Future<List<Marker>> _getHospitalesMarkers() async {
    List<Marker> hospitalesMarkers = [
      Marker(
        markerId: MarkerId('hospital1'),
        position: LatLng(-8.1159, -79.0308), // Coordenas del Hospital 1
        infoWindow: InfoWindow(title: 'Hospital Belén de Trujillo'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hospital.png',
        ),
      ),
      Marker(
        markerId: MarkerId('hospital2'),
        position: LatLng(-8.0996, -79.0121), // Coordenas del Hospital 3
        infoWindow: InfoWindow(title: 'Hospital Victor Lazarte Echegaray'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hospital.png',
        ),
      ),
      // Puedes añadir más hospitales según sea necesario
    ];

    return hospitalesMarkers;
  }

  void _toggleTiendasVisibility() {
    setState(() {
      _showTiendas = !_showTiendas;
    });
  }

  void _toggleHotelesVisibility() {
    setState(() {
      _showHoteles = !_showHoteles;
    });
  }

  void _toggleHospitalesVisibility() {
    setState(() {
      _showHospitales = !_showHospitales;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Ubicación'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('MiUbicacion'),
                position: _currentLocation,
                infoWindow: InfoWindow(title: 'Mi Ubicación'),
              ),
              if (_showTiendas) ..._tiendasMarkers,
              if (_showHoteles) ..._hotelesMarkers,
              if (_showHospitales) ..._hospitalesMarkers,
            },
          ),
          Positioned(
            bottom: 500.0,
            right: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: _toggleTiendasVisibility,
                  child: Icon(_showTiendas ? Icons.close : Icons.store),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: _toggleHotelesVisibility,
                  child: Icon(_showHoteles ? Icons.close : Icons.hotel),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: _toggleHospitalesVisibility,
                  child: Icon(
                      _showHospitales ? Icons.close : Icons.local_hospital),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  final Location _location = Location();
  late LatLng _currentLocation;
  late List<Marker> _tiendasMarkers;
  late List<Marker> _hotelesMarkers;
  late List<Marker> _hospitalesMarkers;
  bool _showTiendas = false;
  bool _showHoteles = false;
  bool _showHospitales = false;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    _currentLocation = await _getLocation();
    _tiendasMarkers = await _getTiendasMarkers();
    _hotelesMarkers = await _getHotelesMarkers();
    _hospitalesMarkers = await _getHospitalesMarkers();
    setState(() {
      // Actualizar el estado después de cargar los marcadores
      _showSnackbar("¡Los marcadores se cargaron exitosamente!");
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<LatLng> _getLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      print("Error getting location: $e");
      return LatLng(0.0, 0.0); // Otra ubicación predeterminada
    }
  }

  Future<List<Marker>> _getTiendasMarkers() async {
    List<Marker> tiendasMarkers = [
      Marker(
        markerId: MarkerId('tiendaRopa1'),
        position: LatLng(-8.1076, -79.0300), // Coordenas de la Tienda 1
        infoWindow: InfoWindow(title: 'Boutique Lola Bunny'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/tienda.png',
        ),
      ),
      Marker(
        markerId: MarkerId('tiendaRopa2'),
        position: LatLng(-8.1185, -79.0229), // Coordenas de la Tienda 2
        infoWindow: InfoWindow(title: 'Tiendas Él'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/tienda.png',
        ),
      ),
      // Puedes añadir más tiendas según sea necesario
    ];

    return tiendasMarkers;
  }

  Future<List<Marker>> _getHotelesMarkers() async {
    List<Marker> hotelesMarkers = [
      Marker(
        markerId: MarkerId('hotel1'),
        position: LatLng(-8.1027, -79.0293), // Coordenas del Hotel 1
        infoWindow: InfoWindow(title: 'Hotel San Isidro'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hotel.png',
        ),
      ),
      Marker(
        markerId: MarkerId('hotel2'),
        position: LatLng(-8.1187, -79.0427), // Coordenas del Hotel 2
        infoWindow: InfoWindow(title: 'Hostal Olimpo'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hotel.png',
        ),
      ),
      // Puedes añadir más hoteles según sea necesario
    ];

    return hotelesMarkers;
  }

  Future<List<Marker>> _getHospitalesMarkers() async {
    List<Marker> hospitalesMarkers = [
      Marker(
        markerId: MarkerId('hospital1'),
        position: LatLng(-8.1159, -79.0308), // Coordenas del Hospital 1
        infoWindow: InfoWindow(title: 'Hospital Belén de Trujillo'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hospital.png',
        ),
      ),
      Marker(
        markerId: MarkerId('hospital2'),
        position: LatLng(-8.0996, -79.0121), // Coordenas del Hospital 3
        infoWindow: InfoWindow(title: 'Hospital Victor Lazarte Echegaray'),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(48, 48)),
          'iconos/hospital.png',
        ),
      ),
      // Puedes añadir más hospitales según sea necesario
    ];

    return hospitalesMarkers;
  }

  void _toggleTiendasVisibility() {
    setState(() {
      _showTiendas = !_showTiendas;
    });
  }

  void _toggleHotelesVisibility() {
    setState(() {
      _showHoteles = !_showHoteles;
    });
  }

  void _toggleHospitalesVisibility() {
    setState(() {
      _showHospitales = !_showHospitales;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Ubicación'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('MiUbicacion'),
                position: _currentLocation,
                infoWindow: InfoWindow(title: 'Mi Ubicación'),
              ),
              if (_showTiendas) ..._tiendasMarkers,
              if (_showHoteles) ..._hotelesMarkers,
              if (_showHospitales) ..._hospitalesMarkers,
            },
          ),
          Positioned(
            bottom: 500.0,
            right: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: _toggleTiendasVisibility,
                  child: Icon(_showTiendas ? Icons.close : Icons.store),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: _toggleHotelesVisibility,
                  child: Icon(_showHoteles ? Icons.close : Icons.hotel),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: _toggleHospitalesVisibility,
                  child: Icon(
                      _showHospitales ? Icons.close : Icons.local_hospital),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
