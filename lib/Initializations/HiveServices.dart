import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thakeren/Initializations/Location.dart';

class HiveServices {
  late Box _box;
  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  HiveServices() {
    initHive();
    _box = Hive.box("Location");

    if (!isLocationDataExists("locationInfo")) {
      requestLocationAndSave();
    }
  }

  Future<void> initHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  void requestLocationAndSave() async {
    Location location = Location();
    await location.getLocation();
    writeLocationData("locationInfo", location.getLocationInfo());
  }

  void writeLocationData(String key, dynamic value) {
    _box.put(key, value);
  }

  dynamic readLocationData(String key) {
    return _box.get(key);
  }

  void deleteLocationData(String key) {
    _box.delete(key);
  }

  void deleteAllLocationData() {
    _box.clear();
  }

  bool isLocationDataExists(String key) {
    return _box.containsKey(key);
  }
}
