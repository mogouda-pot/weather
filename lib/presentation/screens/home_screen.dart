import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/weather_bloc.dart';
import '../../business_logic/cubits/theme_cubit.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  void _loadWeatherData() {
    context.read<WeatherBloc>()
      ..add(const GetCurrentWeatherEvent())
      ..add(const GetForecastEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/image/غامق.jpg'
                  : 'assets/image/فاتح.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDarkMode
                    ? Colors.black.withOpacity(0.7)
                    : Colors.white.withOpacity(0.7),
                isDarkMode
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Weather App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? Colors.amber : Colors.blueGrey,
                  ),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async => _loadWeatherData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildCurrentWeather(),
                      const SizedBox(height: 24),
                      Text(
                        '7-Day Forecast',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildForecast(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDarkMode = context.watch<ThemeCubit>().isDarkMode;
    
    return TextField(
      controller: _searchController,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: 'Search city...',
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.my_location,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: _loadWeatherData,
        ),
        filled: true,
        fillColor: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white30 : Colors.black26,
          ),
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          context.read<WeatherBloc>()
            ..add(GetCurrentWeatherEvent(city: value))
            ..add(GetForecastEvent(city: value));
        }
      },
    );
  }

  Widget _buildCurrentWeather() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state.error != null) {
          return Center(
            child: Text(
              state.error!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                  ),
            ),
          );
        }

        if (state.currentWeather != null) {
          return WeatherCard(weather: state.currentWeather!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildForecast() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state.forecast != null) {
          return ForecastList(forecasts: state.forecast!.dailyForecast);
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}