class Weather {
  String cityName;
  double temperature;
  String conditionText;
  String iconUrl;
  String lastUpdated;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.conditionText,
    required this.iconUrl,
    required this.lastUpdated,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json["location"]["name"],
      temperature: json["current"]["temp_c"].toDouble(),
      conditionText: json["current"]["condition"]["text"],
      iconUrl: "https:${json["current"]["condition"]["icon"]}"
          .replaceAll("64x64", "128x128"),
      lastUpdated: json["current"]["last_updated"],
    );
  }
}

// ✅ أضف هاي الكلاسات الجديدة هون تحت

class HourlyForecast {
  String time;
  double tempC;
  String conditionText;
  String iconUrl;
  int chanceOfRain;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.conditionText,
    required this.iconUrl,
    required this.chanceOfRain,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json["time"],
      tempC: json["temp_c"].toDouble(),
      conditionText: json["condition"]["text"],
      iconUrl: "https:${json["condition"]["icon"]}".replaceAll("64x64", "128x128"),
      chanceOfRain: json["chance_of_rain"] ?? 0,
    );
  }
}

class DayForecast {
  String date;
  double maxTempC;
  double minTempC;
  String conditionText;
  String iconUrl;
  int chanceOfRain;
  List<HourlyForecast> hours;

  DayForecast({
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.conditionText,
    required this.iconUrl,
    required this.chanceOfRain,
    required this.hours,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    List<HourlyForecast> hoursList = (json["hour"] as List)
        .map((h) => HourlyForecast.fromJson(h))
        .toList();

    return DayForecast(
      date: json["date"],
      maxTempC: json["day"]["maxtemp_c"].toDouble(),
      minTempC: json["day"]["mintemp_c"].toDouble(),
      conditionText: json["day"]["condition"]["text"],
      iconUrl: "https:${json["day"]["condition"]["icon"]}".replaceAll("64x64", "128x128"),
      chanceOfRain: json["day"]["daily_chance_of_rain"] ?? 0,
      hours: hoursList,
    );
  }
}

class ForecastWeather {
  Weather current;
  List<DayForecast> days;

  ForecastWeather({
    required this.current,
    required this.days,
  });

  factory ForecastWeather.fromJson(Map<String, dynamic> json) {
    List<DayForecast> daysList = (json["forecast"]["forecastday"] as List)
        .map((d) => DayForecast.fromJson(d))
        .toList();

    return ForecastWeather(
      current: Weather.fromJson(json),
      days: daysList,
    );
  }
}