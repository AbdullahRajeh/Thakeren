import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:thakeren/Initializations/HiveServices.dart';

class Location extends ChangeNotifier {
  late String city;
  late String country;
  late double latitude;
  late double longitude;
  late String time;
  late String date;

  Location() {
    city = '';
    country = '';
    latitude = 0.0;
    longitude = 0.0;
    time = getCurrentTime();
    date = getDate();
    getLocation();

    Timer.periodic(Duration(seconds: 1), (timer) {
      checkAndUpdateTime();
    });
  }

  Map<String, dynamic> getLocationInfo() {
    return {
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'time': time,
      'date': date,
    };
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      notifyListeners();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'ar',
      );

      Placemark place = placemarks[0];

      city = place.locality!;
      country = place.country!;

      notifyListeners();
    } catch (e) {
      HiveServices().deleteLocationData('locationInfo');
    }
  }

  void getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  bool isPermissionGranted() {
    return Geolocator.checkPermission() == LocationPermission.always ||
        Geolocator.checkPermission() == LocationPermission.whileInUse;
  }

  String getCurrentTime() {
    initializeDateFormatting('ar', null);

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('h:mm a', 'ar').format(now);

    return formattedTime;
  }

  void checkAndUpdateTime() {
    String currentTime = getCurrentTime();

    // If the real-time is different from the stored time, update the time
    if (currentTime != time) {
      time = currentTime;
      notifyListeners();
    }
  }

  String getDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM', 'ar').format(now);
    print(formattedDate);
    return formattedDate;
  }

}
