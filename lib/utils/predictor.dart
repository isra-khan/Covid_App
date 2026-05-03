import 'package:covidapp/utils/linear_regression.dart';

class Predictor {
  static List<double> predictNext7(List<int> series) {
    if (series.length < 2) return const [];
    final ys = series.map((e) => e.toDouble()).toList();
    final reg = LinearRegression.fit(ys);
    return List.generate(7, (i) => reg.predict(ys.length + i));
  }

  static double? predictTomorrow(List<int> series) {
    if (series.length < 2) return null;
    final ys = series.map((e) => e.toDouble()).toList();
    final reg = LinearRegression.fit(ys);
    final v = reg.predict(ys.length);
    return v < 0 ? 0 : v;
  }
}
