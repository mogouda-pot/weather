import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/blocs/weather_bloc.dart';
import 'business_logic/cubits/theme_cubit.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final weatherRepository = WeatherRepository();

  runApp(MyApp(
    prefs: prefs,
    weatherRepository: weatherRepository,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final WeatherRepository weatherRepository;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.weatherRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(preferences: prefs),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(repository: weatherRepository),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode == ThemeMode.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
