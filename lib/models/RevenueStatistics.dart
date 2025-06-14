class RevenueStatistics {
  final double dailyRevenue;
  final double monthlyRevenue;
  final double yearlyRevenue;

  RevenueStatistics({
    required this.dailyRevenue,
    required this.monthlyRevenue,
    required this.yearlyRevenue,
  });

  // Метод для создания объекта RevenueStatistics из карты
  factory RevenueStatistics.fromMap(Map<String, dynamic> map) {
    return RevenueStatistics(
      dailyRevenue: map['daily_revenue']?.toDouble() ?? 0.0,
      monthlyRevenue: map['monthly_revenue']?.toDouble() ?? 0.0,
      yearlyRevenue: map['yearly_revenue']?.toDouble() ?? 0.0,
    );
  }
}