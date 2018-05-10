String formatWeight(double weight) => weight.toStringAsFixed(2);

String formatPercentage(double value) => (value * 100).toStringAsFixed(0);

String formatPercent(double value) => '${formatPercentage(value)}%';

String formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';
