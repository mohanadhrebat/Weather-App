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
      iconUrl: "https:${json["current"]["condition"]["icon"]}",
      lastUpdated: json["current"]["last_updated"],
    );
  }
}
