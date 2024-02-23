import 'dart:convert'; // For json.decode
import 'package:http/http.dart' as http; // For http package

class PrayerApi {
  late int method;
  late int month;
  late int year;
  late double latitude;
  late double longitude;

  PrayerApi({
    required this.method,
    required this.month,
    required this.year,
    required this.latitude,
    required this.longitude,
  });

  String get prayerCalendarApi =>
      'http://api.aladhan.com/v1/calendar/$year/$month?latitude=$latitude&longitude=$longitude&method=$method';

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(prayerCalendarApi));

    if (response.statusCode == 200) {
      // Successful request, parse the JSON
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
