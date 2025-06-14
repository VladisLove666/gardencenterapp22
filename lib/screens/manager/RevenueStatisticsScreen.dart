import 'package:flutter/material.dart';
import 'package:gardencenterapppp/models/RevenueStatistics.dart';
import 'package:gardencenterapppp/services/order_service.dart';

class RevenueStatisticsScreen extends StatefulWidget {
  @override
  _RevenueStatisticsScreenState createState() => _RevenueStatisticsScreenState();
}

class _RevenueStatisticsScreenState extends State<RevenueStatisticsScreen> {
  late Future<RevenueStatistics> _revenueStatisticsFuture;

  @override
  void initState() {
    super.initState();
    _revenueStatisticsFuture = OrderService().getRevenueStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика выручки'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<RevenueStatistics>(
        future: _revenueStatisticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Нет данных.'));
          }

          final statistics = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Выручка за день: ${statistics.dailyRevenue} ₽', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('Выручка за месяц: ${statistics.monthlyRevenue} ₽', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('Выручка за год: ${statistics.yearlyRevenue} ₽', style: TextStyle(fontSize: 20)),
              ],
            ),
          );
        },
      ),
    );
  }
}