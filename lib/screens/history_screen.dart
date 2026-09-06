import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

import '../models/daily_summary.dart';
import '../database/database_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DailySummary> dailySummaries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  Future<void> _loadHistory() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final startDate = today.subtract(const Duration(days: 6));

    final endDate = today.add(const Duration(days: 1));

    final meals = await database.getMealsBetween(startDate, endDate);

    final fastingSessions = await database.getFastingSessionsBetween(
      startDate,
      endDate,
    );

    final summaries = List.generate(7, (index) {
      final date = startDate.add(Duration(days: index));

      final caloriesForDay = meals
          .where((meal) => _isSameDay(meal.createdAt, date))
          .fold<int>(0, (total, meal) => total + meal.calories);

      final fastingMinutesForDay = fastingSessions
          .where((session) => _isSameDay(session.endedAt, date))
          .fold<int>(
            0,
            (total, session) => total + session.actualDurationMinutes,
          );

      return DailySummary(
        date: date,
        totalCalories: caloriesForDay,
        totalFastingMinutes: fastingMinutesForDay,
      );
    });

    if (!mounted) return;

    setState(() {
      dailySummaries = summaries.reversed.toList();
      isLoading = false;
    });
  }

  Widget _buildCaloriesChart() {
    final chronologicalSummaries = dailySummaries.reversed.toList();

    final maxCalories = chronologicalSummaries.fold<int>(
      0,
      (max, summary) =>
          summary.totalCalories > max ? summary.totalCalories : max,
    );

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxCalories == 0 ? 100 : maxCalories * 1.2,
          barGroups: List.generate(chronologicalSummaries.length, (index) {
            final summary = chronologicalSummaries[index];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: summary.totalCalories.toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 42),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= chronologicalSummaries.length) {
                    return const SizedBox.shrink();
                  }

                  final date = chronologicalSummaries[index].date;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Últimos 7 dias',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Calorias',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildCaloriesChart(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.separated(
                        itemCount: dailySummaries.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final summary = dailySummaries[index];

                          final day = summary.date.day.toString().padLeft(
                            2,
                            '0',
                          );

                          final month = summary.date.month.toString().padLeft(
                            2,
                            '0',
                          );

                          return Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                              title: Text('$day/$month'),
                              subtitle: Text('${summary.totalCalories} kcal'),
                              trailing: Text(
                                '${summary.totalFastingMinutes} min',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
