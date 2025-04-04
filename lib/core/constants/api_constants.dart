class ApiConstants {
  static const String baseUrl = 'http://api.weatherapi.com/v1';
  static const String apiKey = 'b1a498399cdd4c1a9b6141004250304';
  
  static String currentWeather(String query) =>
      '$baseUrl/forecast.json?key=$apiKey&q=$query&days=1';
  
  static String forecast(String query, {int days = 7}) =>
      '$baseUrl/forecast.json?key=$apiKey&q=$query&days=$days';
}