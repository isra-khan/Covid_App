class LinearRegression {
  final double slope;
  final double intercept;
  LinearRegression(this.slope, this.intercept);

  static LinearRegression fit(List<double> ys) {
    final n = ys.length;
    if (n < 2) return LinearRegression(0, ys.isEmpty ? 0 : ys.first);
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (var i = 0; i < n; i++) {
      sumX += i;
      sumY += ys[i];
      sumXY += i * ys[i];
      sumX2 += i * i;
    }
    final denom = (n * sumX2 - sumX * sumX);
    if (denom == 0) return LinearRegression(0, sumY / n);
    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;
    return LinearRegression(slope, intercept);
  }

  double predict(int x) => slope * x + intercept;
}
