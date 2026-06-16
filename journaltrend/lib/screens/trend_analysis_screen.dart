import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/search_provider.dart';

class TrendAnalysisScreen extends StatelessWidget {
  const TrendAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.currentTopic.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trend Analysis')),
        body: const Center(child: Text('Search for a topic first.')),
      );
    }

    if (provider.isLoadingTrends) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trend Analysis')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Filter out years that are not valid integers or too old/in the future if desired,
    // but usually OpenAlex gives reasonable years.
    final yearlyData = provider.yearlyTrends.where((data) {
      final year = int.tryParse(data.label);
      return year != null && year >= 2000 && year <= DateTime.now().year + 1;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Trend Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Publication Trend: ${provider.currentTopic}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: yearlyData.isEmpty
                  ? const Center(child: Text('Not enough data to display trend.'))
                  : _buildBarChart(context, yearlyData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List yearlyData) {
    int maxCount = 0;
    for (var d in yearlyData) {
      if (d.count > maxCount) maxCount = d.count;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxCount * 1.2).toDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${yearlyData[group.x.toInt()].label}\n${rod.toY.toInt()} pubs',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < yearlyData.length) {
                  // Show every Nth label if there are too many
                  if (yearlyData.length > 10 && value.toInt() % 2 != 0) {
                    return const Text('');
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      yearlyData[value.toInt()].label,
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: yearlyData.asMap().entries.map((entry) {
          int index = entry.key;
          var data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.count.toDouble(),
                color: Theme.of(context).colorScheme.secondary,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
