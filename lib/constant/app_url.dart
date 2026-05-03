class AppUrl {
  static const String baseUrl = "https://disease.sh/v3/covid-19/";

  static const String worldStateApi = baseUrl + "all";
  static const String worldCountries = baseUrl + "countries";

  static String historicalApi(String country, {int days = 30}) =>
      "${baseUrl}historical/$country?lastdays=$days";

  static String countryApi(String country) => "${baseUrl}countries/$country";

  static const String gnewsBase = "https://gnews.io/api/v4/search";
  static String newsApi(String countryName, String apiKey) {
    final query = Uri.encodeQueryComponent(
        '("covid" OR "coronavirus") AND "$countryName"');
    return "$gnewsBase?q=$query&lang=en&max=20&sortby=publishedAt&apikey=$apiKey";
  }
}
