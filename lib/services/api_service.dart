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
      final response = await http.get(Uri.parse("$baseUrl/temperature/1"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final latest = data.firstWhere((item) => item["count"] == 0, orElse: () => null);

        if (latest != null) {
          return {
            "temperature": SensorData(id: latest["count"], date: latest["data"], value: latest["temp"].toDouble()),
            "humidity": SensorData(id: latest["count"], date: latest["data"], value: latest["humi"].toDouble()),
          };
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
    final response = await http.get(Uri.parse("$baseUrl/distance/1"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final latest = data.firstWhere((item) => item["count"] == 0, orElse: () => null);

      if (latest != null) {
        return SensorData(
          id: latest["count"],
          date: latest["data"],
          value: latest["level"].toDouble(),
        );
      }
    }
  } catch (e) {
    print("Error fetching capacity: $e");
  }

  return SensorData(id: 0, date: "0", value: 0);
}

}
