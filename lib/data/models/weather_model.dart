import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final DateTime date;
  final String cityName;
  final double windSpeed;
  final int humidity;

  const WeatherModel({
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.date,
    required this.cityName,
    required this.windSpeed,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final location = json['location'];
    
    return WeatherModel(
      temperature: current['temp_c']?.toDouble() ?? 0.0,
      maxTemp: json['forecast']?['forecastday']?[0]?['day']?['maxtemp_c']?.toDouble() ?? 0.0,
      minTemp: json['forecast']?['forecastday']?[0]?['day']?['mintemp_c']?.toDouble() ?? 0.0,
      condition: current['condition']?['text'] ?? '',
      icon: current['condition']?['icon'] ?? '',
      date: DateTime.parse(location['localtime'] ?? DateTime.now().toString()),
      cityName: location['name'] ?? '',
      windSpeed: current['wind_kph']?.toDouble() ?? 0.0,
      humidity: current['humidity']?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        temperature,
        maxTemp,
        minTemp,
        condition,
        icon,
        date,
        cityName,
        windSpeed,
        humidity,
      ];
}

class ForecastModel extends Equatable {
  final List<WeatherModel> dailyForecast;

  const ForecastModel({required this.dailyForecast});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List<WeatherModel> forecasts = [];
    final forecastDays = json['forecast']?['forecastday'] ?? [];
    final location = json['location'];

    for (var day in forecastDays) {
      forecasts.add(
        WeatherModel(
          temperature: day['day']?['avgtemp_c']?.toDouble() ?? 0.0,
          maxTemp: day['day']?['maxtemp_c']?.toDouble() ?? 0.0,
          minTemp: day['day']?['mintemp_c']?.toDouble() ?? 0.0,
          condition: day['day']?['condition']?['text'] ?? '',
          icon: day['day']?['condition']?['icon'] ?? '',
          date: DateTime.parse(day['date'] ?? DateTime.now().toString()),
          cityName: location['name'] ?? '',
          windSpeed: day['day']?['maxwind_kph']?.toDouble() ?? 0.0,
          humidity: day['day']?['avghumidity']?.toInt() ?? 0,
        ),
      );
    }

    return ForecastModel(dailyForecast: forecasts);
  }

  @override
  List<Object?> get props => [dailyForecast];
}