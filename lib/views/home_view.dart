import 'dart:async';
import 'dart:developer';

import 'package:autobuddy/emergency_contact/GlobalAppBar.dart';
import 'package:autobuddy/emergency_contact/function.dart';
import 'package:autobuddy/functions/speech.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});
  static const String routeName = "/home";

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  setupLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool serviceRequested = await Geolocator.openLocationSettings();
      if (!serviceRequested) {
        return;
      }
    }
  }

  Position? _currentPosition;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  final geo = GeoFlutterFire();
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // Function to get current location of driver using geolocator
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    });
  }

  void _updateLocation() async {
    await _getCurrentPosition();
    GeoFirePoint userLocation = geo.point(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude);
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(userId)
        .update({'position': userLocation.data});
  }

  doesHomeExist() async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('community');

      var doc = await collectionRef.doc(userId).get();
      if (doc.exists) {
        return;
      } else {
        var userData = await FirebaseFirestore.instance
            .collection('userdata')
            .doc(userId)
            .get();
        Map map = userData.data() as Map;
        await _getCurrentPosition();
        GeoFirePoint userLocation = geo.point(
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude);
        collectionRef.doc(userId).set({
          'email': map['email'],
          'phone': map['phone'],
          'position': userLocation.data
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    setupLocation();
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLocation();
    });
    doesHomeExist();
  }

  @override
  Widget build(BuildContext context) {
    List<CameraDescription> cameras = [];
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 0, 0, 255),
      appBar: GlobalAppBar().show("AutoBuddy", ""),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ServiceActivator(cameras: cameras, sms_sender: false),
            SizedBox(
              height: 50,
            ),
            Text(
              "Choose your emergency contacts",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  wordSpacing: 2,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            emergency_cnt(),
          ],
        ),
      ),
    );
  }
}
