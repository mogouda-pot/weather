import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, d MMMM').format(weather.date),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https:${weather.icon}',
                  width: 64,
                  height: 64,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.cloud,
                    size: 64,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${weather.temperature.round()}°C',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              weather.condition,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  context,
                  Icons.thermostat,
                  'Max',
                  '${weather.maxTemp.round()}°C',
                ),
                _buildWeatherInfo(
                  context,
                  Icons.thermostat_auto,
                  'Min',
                  '${weather.minTemp.round()}°C',
                ),
                _buildWeatherInfo(
                  context,
                  Icons.air,
                  'Wind',
                  '${weather.windSpeed} km/h',
                ),
                _buildWeatherInfo(
                  context,
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}