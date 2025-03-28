import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';

class PeatDataService {
  static String? get baseUrl => dotenv.env['BASE_URL'];
  static String get _appEndpoint => '';

  static Future<T?> _fetchSingle<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$_appEndpoint/$endpoint"));
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List && body.isNotEmpty) {
          return fromJson(body.first);
        } else if (body is Map<String, dynamic>) {
          return fromJson(body);
        }
      } else {
        print('Failed to fetch $endpoint: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching $endpoint: $e');
    }
    return null;
  }

  static Future<List<T>> _fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$_appEndpoint/$endpoint"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => fromJson(item)).toList().reversed.toList();
      } else {
        print('Failed to fetch list from $endpoint: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching list from $endpoint: $e');
    }
    return [];
  }

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    final sensorData = await _fetchSingle(
      "sensor_data/last/1",
      (json) => SensorData(
        date: json["date"] as String? ?? "",
        temperature: (json["temp"] as num? ?? 0).toDouble(),
        humidity: (json["humi"] as num? ?? 0).toDouble(),
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
      "sensor_data/avg/$n",
      (json) => SensorData(
        date: json["date"] as String? ?? "0",
        temperature: (json["temp"] as num? ?? 0).toDouble(),
        humidity: (json["humi"] as num? ?? 0).toDouble(),
      ),
    );
  }

  static Future<SensorLevel> fetchCapacity() async {
    final sensorLevel = await _fetchSingle(
      "level/last/1",
      (json) => SensorLevel(
        date: json["date"] as String? ?? "",
        capacity: (json["level"] as num? ?? 0).toDouble(),
      ),
    );
    return sensorLevel ?? SensorLevelExtension.empty();
  }

  static Future<List<SensorData>> fetchLastNAvgTemperatures(int n) async {
    return _fetchList(
      "sensor_data/avg/$n",
      (json) => SensorData(
        date: json["date"] as String? ?? "00/00",
        temperature: (json["temp"] as num? ?? 0).toDouble(),
        humidity: (json["humi"] as num? ?? 0).toDouble(),
      ),
    );
  }

  static Future<List<SensorLevel>> fetchLastNAvgLevels(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl$_appEndpoint/level/avg/$n"));
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        if (body is List) {
          return body
              .map((json) => SensorLevel(
                    date: json["date"] as String? ?? "0",
                    capacity: (json["level"] as num? ?? 0).toDouble(),
                  ))
              .toList()
              .reversed
              .toList();
        } else {
          print('Unexpected response format for level/avg/$n: $body');
          return [];
        }
      } else {
        print('Failed to fetch level/avg/$n: Status code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching level/avg/$n: $e');
      return [];
    }
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityByDate(
    String date,
  ) async {
    return _fetchList(
      "sensor_data/date/$date",
      (json) => SensorData(
        date: json["date"] as String? ?? "0",
        temperature: (json["temp"] as num? ?? 0).toDouble(),
        humidity: (json["humi"] as num? ?? 0).toDouble(),
      ),
    );
  }

  static Future<List<SensorLevel>> fetchCapacityByDate(String date) async {
    return _fetchList(
      "level/date/$date",
      (json) => SensorLevel(
        date: json["date"] as String? ?? "0",
        capacity: (json["level"] as num? ?? 0).toDouble(),
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
    return SensorData(date: "0", temperature: 0, humidity: 0);
  }
  static SensorData emptyWithDate(String date) {
    return SensorData(date: date, temperature: 0, humidity: 0);
  }
}

extension SensorLevelExtension on SensorLevel {
  static SensorLevel empty() {
    return SensorLevel(date: "0", capacity: 0);
  }
}