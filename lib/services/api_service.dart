import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peatdashboard/models/sensor_data.dart';
import 'package:peatdashboard/models/sensor_level.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importe o pacote

class ApiService {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8002"; // Carrega a baseUrl do .env

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/temperature/last/1"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final latest = data.firstWhere(
            (item) => item["count"] == 0,
            orElse: () => null,
          );

          if (latest != null) {
            return {
              "temperature": SensorData(
                id: latest["count"],
                date: _validateDate(latest["date"]),
                temperature: latest["temp"].toDouble(),
                humidity: latest["humi"].toDouble(),
              ),
              "humidity": SensorData(
                id: latest["count"],
                date: _validateDate(latest["date"]),
                temperature: latest["temp"].toDouble(),
                humidity: latest["humi"].toDouble(),
              ),
            };
          }
        }
      }
    } catch (e) {
      print("Error fetching temperature/humidity: $e");
    }
    return {
      "temperature": SensorData(
        id: 0,
        date: "0",
        temperature: 0,
        humidity: 0,
      ),
      "humidity": SensorData(
        id: 0,
        date: "0",
        temperature: 0,
        humidity: 0,
      ),
    };
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityList(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/temperature/avg/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<SensorData> sensorDataList = data
            .map((item) => SensorData(
                  id: item["count"],
                  date: item["date"],
                  temperature: item["temp"].toDouble(),
                  humidity: item["humi"].toDouble(),
                ))
            .toList()
            .reversed
            .toList();

        return sensorDataList;
      }
    } catch (e) {
      print("Error fetching temperature/humidity list: $e");
    }
    return [];
  }

  static Future<SensorLevel> fetchCapacity() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/level/last/1"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final latest = data.firstWhere(
            (item) => item["count"] == 0,
            orElse: () => null,
          );

          if (latest != null) {
            return SensorLevel(
              id: latest["count"],
              date: _validateDate(latest["date"]),
              capacity: latest["level"].toDouble(),
            );
          }
        }
      }
    } catch (e) {
      print("Error fetching capacity: $e");
    }
    return SensorLevel(
      id: 0,
      date: "0",
      capacity: 0,
    );
  }

  static Future<List<SensorData>> fetchLastNAverageTemperatures(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/temperature/avg/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((item) => SensorData(
                  id: item["count"] ?? 0,
                  date: (item["date"] != null && item["date"] is String) ? item["date"] : "00/00",
                  temperature: (item["temp"] != null) ? item["temp"].toDouble() : 0.0,
                  humidity: (item["humi"] != null) ? item["humi"].toDouble() : 0.0,
                ))
            .toList()
            .reversed
            .toList();
      }
    } catch (e) {
      print("Error fetching last N average temperatures: $e");
    }
    return [];
  }

  static String _validateDate(String date) {
    if (date.isEmpty || !RegExp(r"^\d{4}-\d{2}-\d{2}").hasMatch(date)) {
      return "0";
    }
    return date;
  }

  static Future<List<SensorLevel>> fetchLastNAvgLevels(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/level/avg/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((item) => SensorLevel(
                  id: item["count"] ?? 0,
                  date: item["date"],
                  capacity: (item["level"] != null) ? item["level"].toDouble() : 0.0,
                ))
            .toList()
            .reversed
            .toList();
      }
    } catch (e) {
      print("Error fetching last N average temperatures: $e");
    }
    return [];
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityByDate(String date) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/app/temperature/date/$date"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        List<SensorData> sensorDataList = data
            .map((item) => SensorData(
                  id: item["count"],
                  date: item["date"],
                  temperature: item["temp"].toDouble(),
                  humidity: item["humi"].toDouble(),
                ))
            .toList()
            .reversed
            .toList();

        return sensorDataList;
      }
    } catch (e) {
      print("Error fetching temperature/humidity by date: $e");
    }
    return [];
  }
}