import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorData {
  final int id;
  final String date;
  final double value;

  SensorData({required this.id, required this.date, required this.value});
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
                date: _validateDate(latest["data"]),
                value: latest["temp"].toDouble(),
              ),
              "humidity": SensorData(
                id: latest["count"],
                date: _validateDate(latest["data"]),
                value: latest["humi"].toDouble(),
              ),
            };
          }
        }
      }
    } catch (e) {
      print("Error fetching temperature/humidity: $e");
    }
    return {
      "temperature": SensorData(id: 0, date: "0", value: 0),
      "humidity": SensorData(id: 0, date: "0", value: 0),
    };
  }

  static Future<SensorData> fetchCapacity() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/distance/last/1"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final latest = data.firstWhere(
                (item) => item["count"] == 0,
            orElse: () => null,
          );

          if (latest != null) {
            return SensorData(
              id: latest["count"],
              date: _validateDate(latest["data"]),
              value: latest["level"].toDouble(),
            );
          }
        }
      }
    } catch (e) {
      print("Error fetching capacity: $e");
    }
    return SensorData(id: 0, date: "0", value: 0);
  }

  static Future<List<SensorData>> fetchTemperatureAndHumidityList(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/temperature/last/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Directly map all items to SensorData and reverse the list
        List<SensorData> sensorDataList = data.map((item) => SensorData(
          id: item["count"],
          date: _validateDate(item["data"]),
          value: item["temp"].toDouble(),
        )).toList();

        // Reverse the list to have the most recent data first
        return sensorDataList.reversed.toList();  // Now most recent data is first
      }
    } catch (e) {
      print("Error fetching temperature/humidity list: $e");
    }
    return [];
  }



  static Future<List<SensorData>> fetchCapacityList(int n) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/distance/last/$n"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .where((item) => item["count"] == 0)
              .map((item) => SensorData(
            id: item["count"],
            date: _validateDate(item["data"]),
            value: item["level"].toDouble(),
          ))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching capacity list: $e");
    }
    return [];
  }

  static String _validateDate(String date) {
    if (date.isEmpty || !RegExp(r"^\d{4}-\d{2}-\d{2}").hasMatch(date)) {
      return "0";
    }
    return date;
  }
}
