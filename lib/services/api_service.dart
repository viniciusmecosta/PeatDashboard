import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorData {
  final int id;
  final String date;
  final double temperature;
  final double humidity;

  SensorData({
    required this.id,
    required this.date,
    required this.temperature,
    required this.humidity,
  });
}

class SensorLevel {
  final int id;
  final String date;
  final double capacity;

  SensorLevel({
    required this.id,
    required this.date,
    required this.capacity,
  });
}

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8002";

  static Future<Map<String, SensorData>> fetchTemperatureAndHumidity() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/temperature/last/1"));
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
      final response = await http.get(Uri.parse("$baseUrl/temperature/last/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Map all items to SensorData objects
        List<SensorData> sensorDataList = data.map((item) => SensorData(
          id: item["count"],
          date: _validateDate(item["date"]),
          temperature: item["temp"].toDouble(),
          humidity: item["humi"].toDouble(),
        )).toList();

        // Reverse the list to have the most recent data first
        return sensorDataList.reversed.toList();
      }
    } catch (e) {
      print("Error fetching temperature/humidity list: $e");
    }
    return [];
  }

  static Future<SensorLevel> fetchCapacity() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/level/last/1"));
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

  static String _validateDate(String date) {
    if (date.isEmpty || !RegExp(r"^\d{4}-\d{2}-\d{2}").hasMatch(date)) {
      return "0";
    }
    return date;
  }
}
