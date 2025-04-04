import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentWeatherEvent extends WeatherEvent {
  final String? city;
  const GetCurrentWeatherEvent({this.city});

  @override
  List<Object?> get props => [city];
}

class GetForecastEvent extends WeatherEvent {
  final String? city;
  const GetForecastEvent({this.city});

  @override
  List<Object?> get props => [city];
}

// States
class WeatherState extends Equatable {
  final WeatherModel? currentWeather;
  final ForecastModel? forecast;
  final bool isLoading;
  final String? error;

  const WeatherState({
    this.currentWeather,
    this.forecast,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    WeatherModel? currentWeather,
    ForecastModel? forecast,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [currentWeather, forecast, isLoading, error];
}

// Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc({required this.repository}) : super(const WeatherState()) {
    on<GetCurrentWeatherEvent>(_getCurrentWeather);
    on<GetForecastEvent>(_getForecast);
  }

  Future<void> _getCurrentWeather(
    GetCurrentWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final weather = event.city != null
          ? await repository.getCurrentWeather(event.city!)
          : await repository.getWeatherByLocation();
      emit(state.copyWith(
        currentWeather: weather,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _getForecast(
    GetForecastEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final forecast = event.city != null
          ? await repository.getForecast(event.city!)
          : await repository.getForecastByLocation();
      emit(state.copyWith(
        forecast: forecast,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }
}