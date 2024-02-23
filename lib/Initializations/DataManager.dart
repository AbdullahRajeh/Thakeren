import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:thakeren/Initializations/PrayerApi.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class DataManager {
  late String PrayerApiLink;
  var box = Hive.box('prayerDataBox');
  var data;
  DataManager() {
    PrayerApiLink;
  }

  Future<void> downloadAndCacheData() async {
    try {
      final response = await http.get(Uri.parse(PrayerApiLink));

      if (response.statusCode == 200) {
        // Successful request, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Save data to Hive for future use
        box.put('cachedData', json.encode(data));

        print('Downloaded and cached data: $data');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to download data');
      }
    } catch (e) {
      // Handle exception, e.g., no internet connection
      print('Error downloading data: $e');
    }
  }

  // Fetch data from Hive if available, otherwise download from API
  bool isPrayerDataAvailable() {
    if (Hive.isBoxOpen('prayerDataBox')) {
      var box = Hive.box('prayerDataBox');
      return box.isNotEmpty;
    }
    return false;
  }

  // Fetch data from Hive if available, otherwise download from API
  void getData() {
    if (isPrayerDataAvailable()) {
      var box = Hive.box('prayerDataBox');
      return box.get('cachedData');
    }
    return null;
  }

  Future<void> fetchDataWithoutDownloading() async {
    await Hive.initFlutter();

    // Open the Hive box
    var box = await Hive.openBox('prayerDataBox');

    // Check if data is available in Hive
    String? cachedData = box.get('cachedData');

    if (cachedData != null && cachedData.isNotEmpty) {
      // Use cached data
      final Map<String, dynamic> data = json.decode(cachedData);
      print('Using cached data: $data');
    } else {
      // If cached data is not available, try fetching from API
      try {
        final response = await http.get(Uri.parse(PrayerApiLink));

        if (response.statusCode == 200) {
          // Successful request, parse the JSON
          final Map<String, dynamic> data = json.decode(response.body);

          // Save data to Hive for future use
          box.put('cachedData', json.encode(data));

          print('Downloaded and cached data: $data');
        } else {
          // If the server did not return a 200 OK response,
          // throw an exception.
          throw Exception('Failed to fetch data');
        }
      } catch (e) {
        // Handle exception, e.g., no internet connection
        print('Error fetching data: $e');
      }
    }
  }
}
