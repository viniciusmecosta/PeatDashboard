import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';

class PeatDataService {
  static String? get baseUrl => dotenv.env['BASE_URL'];
  static String? get apiToken => dotenv.env['API_TOKEN'];

  static Future<T?> _fetchSingle<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {'Authorization': 'Bearer $apiToken'},
      );

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List && body.isNotEmpty) {
          return fromJson(body.first);
        } else if (body is Map<String, dynamic>) {
          return fromJson(body);
        }
      }
    } catch (e) {
      // Silent fail handled by fallback
    }
    return null;
  }

  static Future<List<T>> _fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: {'Authorization': 'Bearer $apiToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => fromJson(item)).toList().reversed.toList();
      }
    } catch (e) {
      // Silent fail handled by fallback
    }
    return [];
  }

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    final sensorData = await _fetchSingle(
      "temp-humi/last/1",
      (json) => SensorData(
        date: json["date"] as String? ?? "n/d",
        temperature: (json["temp"] as num? ?? 20).toDouble(),
        humidity: (json["humi"] as num? ?? 20).toDouble(),
      ),
    );

    if (sensorData != null) {
      return {"temperature": sensorData, "humidity": sensorData};
    } else {
      return {
        "temperature": SensorDataExtension.empty(),
        "humidity": SensorDataExtension.empty(),
      };
    }
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityList(int n) async {
    return _fetchList(
      "temp-humi/avg/$n",
      (json) => SensorData(
        date: json["date"] as String? ?? "n/d",
        temperature: (json["temp"] as num? ?? 20).toDouble(),
        humidity: (json["humi"] as num? ?? 20).toDouble(),
      ),
    );
  }

  static Future<SensorLevel> fetchCapacity() async {
    final sensorLevel = await _fetchSingle(
      "level/last/1",
      (json) => SensorLevel(
        date: json["date"] as String? ?? "n/d",
        capacity: (json["level"] as num? ?? 20).toDouble(),
      ),
    );
    return sensorLevel ?? SensorLevelExtension.empty();
  }

  static Future<List<SensorData>> fetchLastNAvgTemperatures(int n) async {
    return _fetchList(
      "temp-humi/avg/$n",
      (json) => SensorData(
        date: json["date"] as String? ?? "n/d",
        temperature: (json["temp"] as num? ?? 20).toDouble(),
        humidity: (json["humi"] as num? ?? 20).toDouble(),
      ),
    );
  }

  static Future<List<SensorLevel>> fetchLastNAvgLevels(int n) async {
    final response = await http.get(
      Uri.parse("$baseUrl/level/avg/$n"),
      headers: {'Authorization': 'Bearer $apiToken'},
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      if (body is List) {
        return body
            .map(
              (json) => SensorLevel(
                date: json["date"] as String? ?? "n/d",
                capacity: (json["level"] as num? ?? 20).toDouble(),
              ),
            )
            .toList()
            .reversed
            .toList();
      }
    }

    return [];
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityByDate(
    String date,
  ) async {
    return _fetchList(
      "temp-humi/date/$date",
      (json) => SensorData(
        date: json["date"] as String? ?? "n/d",
        temperature: (json["temp"] as num? ?? 20).toDouble(),
        humidity: (json["humi"] as num? ?? 20).toDouble(),
      ),
    );
  }

  static Future<List<SensorLevel>> fetchCapacityByDate(String date) async {
    return _fetchList(
      "level/date/$date",
      (json) => SensorLevel(
        date: json["date"] as String? ?? "n/d",
        capacity: (json["level"] as num? ?? 20).toDouble(),
      ),
    );
  }

  static Future<SensorData> fetchAverageTemperatureAndHumidity(int n) async {
    final List<SensorData> data = await fetchTemperatureAndHumidityList(n);

    if (data.isEmpty) {
      return SensorDataExtension.emptyWithDate(DateTime.now().toString());
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

extension SensorDataExtension on SensorData {
  static SensorData empty() {
    return SensorData(date: "n/d", temperature: 20, humidity: 10);
  }

  static SensorData emptyWithDate(String date) {
    return SensorData(date: date, temperature: 20, humidity: 10);
  }
}

extension SensorLevelExtension on SensorLevel {
  static SensorLevel empty() {
    return SensorLevel(date: "n/d", capacity: 10);
  }
}
