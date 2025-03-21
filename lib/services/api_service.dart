import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static String? get baseUrl => dotenv.env['BASE_URL'];

  static Future<T?> _fetchData<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return fromJson(data.first);
        }
      }
    } catch (e) {
      print("Error fetching data from $endpoint: $e");
    }
    return null;
  }

  static Future<List<T>> _fetchListData<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => fromJson(item)).toList().reversed.toList();
      }
    } catch (e) {
      print("Error fetching list data from $endpoint: $e");
    }
    return [];
  }

  static String _validateDate(String date) {
    if (date.isEmpty || !RegExp(r"^\d{4}-\d{2}-\d{2}").hasMatch(date)) {
      return "0";
    }
    return date;
  }

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    final sensorData = await _fetchData("app/temperature/last/1", (json) => SensorData(
      id: json["count"] ?? 0,
      date: _validateDate(json["date"] ?? ""),
      temperature: (json["temp"] ?? 0).toDouble(),
      humidity: (json["humi"] ?? 0).toDouble(),
    ));

    if (sensorData != null) {
      return {
        "temperature": sensorData,
        "humidity": sensorData,
      };
    } else {
      return {
        "temperature": SensorData(id: 0, date: "0", temperature: 0, humidity: 0),
        "humidity": SensorData(id: 0, date: "0", temperature: 0, humidity: 0),
      };
    }
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityList(int n) async {
    return _fetchListData("app/temperature/avg/$n", (json) => SensorData(
      id: json["count"] ?? 0,
      date: json["date"] ?? "0",
      temperature: (json["temp"] ?? 0).toDouble(),
      humidity: (json["humi"] ?? 0).toDouble(),
    ));
  }

  static Future<SensorLevel> fetchCapacity() async {
    try {
      return await _fetchData("app/level/last/1", (json) => SensorLevel(
        id: json["count"] ?? 0,
        date: _validateDate(json["date"] ?? ""),
        capacity: (json["level"] ?? 0).toDouble(),
      )) ??
          SensorLevel(id: 0, date: "0", capacity: 0);
    } catch (e) {
      print("Error in fetchCapacity: $e");
      return SensorLevel(id: 0, date: "0", capacity: 0);
    }
  }

  static Future<List<SensorData>> fetchLastNAverageTemperatures(int n) async {
    return _fetchListData("app/temperature/avg/$n", (json) => SensorData(
      id: json["count"] ?? 0,
      date: json["date"] ?? "00/00",
      temperature: (json["temp"] ?? 0).toDouble(),
      humidity: (json["humi"] ?? 0).toDouble(),
    ));
  }

  static Future<List<SensorLevel>> fetchLastNAvgLevels(int n) async {
    return _fetchListData("app/level/avg/$n", (json) => SensorLevel(
      id: json["count"] ?? 0,
      date: json["date"] ?? "0",
      capacity: (json["level"] ?? 0).toDouble(),
    ));
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityByDate(String date) async {
    return _fetchListData("app/temperature/date/$date", (json) => SensorData(
      id: json["count"] ?? 0,
      date: json["date"] ?? "0",
      temperature: (json["temp"] ?? 0).toDouble(),
      humidity: (json["humi"] ?? 0).toDouble(),
    ));
  }

  static Future<List<SensorLevel>> fetchCapacityByDate(String date) async {
    return _fetchListData("app/level/date/$date", (json) => SensorLevel(
      id: json["count"] ?? 0,
      date: json["date"] ?? "0",
      capacity: (json["level"] ?? 0).toDouble(),
    ));
  }
}