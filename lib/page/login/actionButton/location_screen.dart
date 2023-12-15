// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ib_sme_mb_view/enum/enum.dart';
import 'package:ib_sme_mb_view/network/services/locations_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../../../common/form_input_and_label/search_input.dart';
import 'package:ib_sme_mb_view/model/models.dart';
import '../../../utils/theme.dart';

class MyLocationScreen extends StatefulWidget {
  const MyLocationScreen({super.key});

  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  final Map<String, Marker> _markers = {};
  late GoogleMapController _controller;
  late PermissionStatus _permissionStatus;
  late bool _locationEnabled = false;
  static const CameraPosition _intiLocation =
      CameraPosition(target: LatLng(21.0285, 105.8542), zoom: 10);

  List<Location> listLocations = [];
  // List<Location> searchResults = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _checkPermissionStatus() async {
    _permissionStatus = await Permission.location.status;
    if (_permissionStatus.isGranted) {
      _enableLocation();
    }
  }

  _init() async {
    _permissionStatus = await Permission.location.status;
    if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
      await Permission.location.request();
    }
    _checkPermissionStatus();
  }

  void _enableLocation() async {
    await Geolocator.isLocationServiceEnabled().then((isEnabled) {
      if (isEnabled) {
        setState(() {
          _locationEnabled = true;
        });
        _getCurrentLocation();
      } else {
        setState(() {
          _locationEnabled = false;
        });
      }
    });
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 13.0,
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    BaseResponseDataList response = await LocationsService().getAllLocation();
    if (response.errorCode == FwError.THANHCONG.value) {
      listLocations = response.data!.map((e) => Location.fromJson(e)).toList();
      setState(() {
        _markers.clear();
        for (final office in listLocations) {
          try {
            List<String> latLng = office.location.split(',');
            final marker = Marker(
              markerId: MarkerId(office.name),
              position:
                  LatLng(double.parse(latLng[0]), double.parse(latLng[1])),
              infoWindow: InfoWindow(
                title: office.name,
                snippet: office.address,
              ),
            );
            _markers[office.name] = marker;
          } catch (_) {}
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ATM/Chi nhánh"),
          centerTitle: true,
          toolbarHeight: 55,
          flexibleSpace: Image.asset(
            'assets/images/backgroungAppbar.png',
            fit: BoxFit.cover,
          ),
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: _showSearchBox,
          //   ),
          // ],
        ),
        body: renderMap());
  }

  _showSearchBox() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return BranchsWidget(
          callback: (value) => _moveCamera(value),
          controller: _controller,
          listLocations: listLocations,
        );
      },
    );
  }

  renderMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      zoomControlsEnabled: false,
      myLocationEnabled: _locationEnabled,
      initialCameraPosition: _intiLocation,
      markers: _markers.values.toSet(),
    );
  }

  _moveCamera(LatLng latLng) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 15.0,
        ),
      ),
    );
    Navigator.of(context).pop();
  }
}

class BranchsWidget extends StatefulWidget {
  final Function callback;
  final GoogleMapController controller;
  final List<Location> listLocations;
  const BranchsWidget(
      {super.key,
      required this.callback,
      required this.controller,
      required this.listLocations});

  @override
  State<BranchsWidget> createState() => _BranchsWidgetState();
}

class _BranchsWidgetState extends State<BranchsWidget> {
  final searchController = TextEditingController();
  List<Location> searchResults = [];
  @override
  void initState() {
    super.initState();
    searchResults = widget.listLocations;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.sizeOf(context).height,
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        // height: MediaQuery.sizeOf(context).height * .35,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SearchInput(
                searchController: searchController,
                searchAction: (String value) {
                  var searchTerm = value.toLowerCase();
                  setState(() {
                    searchResults = widget.listLocations
                        .where((branch) =>
                            branch.name.toLowerCase().contains(searchTerm))
                        .toList();
                  });
                },
              ),
              renderListLocations(searchResults),
            ],
          ),
        ),
      ),
    );
  }

  renderListLocations(List<Location> listSearchs) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listSearchs.length,
        itemBuilder: (context, index) {
          var item = listSearchs[index];
          var latLng = _getLatLng(item);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => widget.callback(latLng),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.address),
                ),
              ),
              renderLine()
            ],
          );
        },
      ),
    );
  }

  LatLng _getLatLng(Location location) {
    List<String> tatLng = location.location.split(',');
    double latitude = double.parse(tatLng[0]);
    double longitude = double.parse(tatLng[1]);
    return LatLng(latitude, longitude);
  }

  renderLine() {
    return const Divider(
      color: coloreWhite_EAEBEC, // Màu của đường kẻ
      thickness: 1.0, // Độ dày của đường kẻ
    );
  }
}
