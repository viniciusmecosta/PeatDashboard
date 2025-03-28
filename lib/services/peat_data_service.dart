import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';

class PeatDataService {
  static String? get baseUrl => dotenv.env['BASE_URL'];

  static Future<T?> _fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return fromJson(data.first);
        }
      }
    } catch (e) {}
    return null;
  }

  static Future<List<T>> _fetchListData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => fromJson(item)).toList().reversed.toList();
      }
    } catch (e) {}
    return [];
  }

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    final sensorData = await _fetchData(
      "sensor_data/last/1",
      (json) => SensorData(
        date: json["date"] ?? "",
        temperature: (json["temp"] ?? 0).toDouble(),
        humidity: (json["humi"] ?? 0).toDouble(),
      ),
    );

    if (sensorData != null) {
      return {"temperature": sensorData, "humidity": sensorData};
    } else {
      return {
        "temperature": SensorData(date: "0", temperature: 0, humidity: 0),
        "humidity": SensorData(date: "0", temperature: 0, humidity: 0),
      };
    }
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityList(int n) async {
    return _fetchListData(
      "sensor_data/avg/$n",
      (json) => SensorData(
        date: json["date"] ?? "0",
        temperature: (json["temp"] ?? 0).toDouble(),
        humidity: (json["humi"] ?? 0).toDouble(),
      ),
    );
  }

  static Future<SensorLevel> fetchCapacity() async {
    try {
      final response = await _fetchData("level/last/1", (json) {
        return SensorLevel(
          date: json["date"] ?? "",
          capacity: (json["level"] ?? 0).toDouble(),
        );
      });

      if (response != null) {
        return response;
      } else {
        return SensorLevel(date: "0", capacity: 0);
      }
    } catch (e) {
      return SensorLevel(date: "0", capacity: 0);
    }
  }

  static Future<List<SensorData>> fetchLastNAvgTemperatures(int n) async {
    return _fetchListData(
      "sensor_data/avg/$n",
      (json) => SensorData(
        date: json["date"] ?? "00/00",
        temperature: (json["temp"] ?? 0).toDouble(),
        humidity: (json["humi"] ?? 0).toDouble(),
      ),
    );
  }

  static Future<List<SensorLevel>> fetchLastNAvgLevels(int n) async {
    final response = await http.get(Uri.parse("$baseUrl/level/avg/$n"));
    final data = jsonDecode(response.body);
    return (data is List)
        ? data
            .map(
              (json) => SensorLevel(
                date: json["date"] ?? "0",
                capacity: (json["level"] ?? 0).toDouble(),
              ),
            )
            .toList()
            .reversed
            .toList()
        : [];
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityByDate(
    String date,
  ) async {
    final data = await _fetchListData(
      "sensor_data/date/$date",
      (json) => SensorData(
        date: json["date"] ?? "0",
        temperature: (json["temp"] ?? 0).toDouble(),
        humidity: (json["humi"] ?? 0).toDouble(),
      ),
    );
    return data.isEmpty ? [] : data;
  }

  static Future<List<SensorLevel>> fetchCapacityByDate(String date) async {
    final data = await _fetchListData(
      "level/date/$date",
      (json) => SensorLevel(
        date: json["date"] ?? "0",
        capacity: (json["level"] ?? 0).toDouble(),
      ),
    );
    return data.isEmpty ? [] : data;
  }

  static Future<SensorData> fetchAverageTemperatureAndHumidity(int n) async {
    final List<SensorData> data = await _fetchListData(
      "sensor_data/avg/$n",
      (json) => SensorData(
        date: json["date"] ?? "0",
        temperature: (json["temp"] ?? 0).toDouble(),
        humidity: (json["humi"] ?? 0).toDouble(),
      ),
    );

    if (data.isEmpty) {
      return SensorData(date: "00/00", temperature: 0.0, humidity: 0.0);
    }

    double totalTemp = data.fold(0, (sum, item) => sum + item.temperature);
    double totalHumi = data.fold(0, (sum, item) => sum + item.humidity);

    return SensorData(
      date: DateTime.now().toString(),
      temperature: totalTemp / data.length,
      humidity: totalHumi / data.length,
    );
  }
}
