import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../../core/constants/api_constants.dart';

class WeatherRepository {
  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.currentWeather(city)));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service');
    }
  }

  Future<ForecastModel> getForecast(String city) async {
    try {
      final response = await http.get(Uri.parse(ApiConstants.forecast(city)));
      if (response.statusCode == 200) {
        return ForecastModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> getWeatherByLocation() async {
    try {
      final position = await getCurrentLocation();
      return getCurrentWeather('${position.latitude},${position.longitude}');
    } catch (e) {
      throw Exception('Failed to get weather for current location: $e');
    }
  }

  Future<ForecastModel> getForecastByLocation() async {
    try {
      final position = await getCurrentLocation();
      return getForecast('${position.latitude},${position.longitude}');
    } catch (e) {
      throw Exception('Failed to get forecast for current location: $e');
    }
  }
}