import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/weather_model.dart';

class ForecastCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isToday;

  const ForecastCard({
    Key? key,
    required this.weather,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              isToday
                  ? 'Today'
                  : DateFormat('EEEE').format(weather.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Image.network(
              'https:${weather.icon}',
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.cloud,
                size: 48,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.round()}°C',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              weather.condition,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.arrow_upward, size: 16),
                    Text(
                      '${weather.maxTemp.round()}°',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.arrow_downward, size: 16),
                    Text(
                      '${weather.minTemp.round()}°',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastList extends StatelessWidget {
  final List<WeatherModel> forecasts;

  const ForecastList({
    Key? key,
    required this.forecasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 140,
              child: ForecastCard(
                weather: forecasts[index],
                isToday: index == 0,
              ),
            ),
          );
        },
      ),
    );
  }
}