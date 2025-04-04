import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wether_app/data/repositories/weather_repository.dart';
import 'package:wether_app/main.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockWeatherRepository mockWeatherRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockWeatherRepository = MockWeatherRepository();
  });

  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(
      prefs: prefs,
      weatherRepository: mockWeatherRepository,
    ));

    expect(find.text('Weather App'), findsOneWidget);
  });
}
