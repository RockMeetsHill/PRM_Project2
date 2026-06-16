import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/search_provider.dart';
import '../models/trend_data.dart';

class TrendAnalysisScreen extends StatefulWidget {
  const TrendAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<TrendAnalysisScreen> createState() => _TrendAnalysisScreenState();
}

class _TrendAnalysisScreenState extends State<TrendAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    if (provider.currentTopic.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F172A), Color(0xFF1E1E2F)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 80, color: Colors.indigoAccent.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No Search Topic Yet',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Search for a topic first to analyze research trends.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (provider.isLoadingTrends) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F172A), Color(0xFF1E1E2F)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.indigoAccent),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1F2937)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Research Analytics',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Insights for: ',
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.indigoAccent.withOpacity(0.4)),
                          ),
                          child: Text(
                            provider.currentTopic,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Dropdown Selection Menu (using PopupMenuButton for fixed positioning)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: const Color(0xFF1E293B),
                  ),
                  child: PopupMenuButton<String>(
                    initialValue: provider.selectedChart,
                    offset: const Offset(0, 52), // Position menu directly below the button container
                    onSelected: (String newValue) {
                      provider.setSelectedChart(newValue);
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'publications',
                        child: Text(
                          'Publications Trend',
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'authors',
                        child: Text(
                          'Top Contributing Authors',
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'journals',
                        child: Text(
                          'Journal Shares',
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'productivity',
                        child: Text(
                          'Author Productivity vs Impact',
                          style: GoogleFonts.outfit(color: Colors.white),
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getChartTitle(provider.selectedChart),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.indigoAccent),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tab View Content (dynamic selection)
              Expanded(
                child: Builder(
                  builder: (context) {
                    switch (provider.selectedChart) {
                      case 'publications':
                        return _buildPublicationsTrendTab(provider);
                      case 'authors':
                        return _buildTopAuthorsTab(provider);
                      case 'journals':
                        return _buildJournalSharesTab(provider);
                      case 'productivity':
                      default:
                        return _buildAuthorProductivityTab(provider);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getChartTitle(String key) {
    switch (key) {
      case 'publications':
        return 'Publications Trend';
      case 'authors':
        return 'Top Contributing Authors';
      case 'journals':
        return 'Journal Shares';
      case 'productivity':
      default:
        return 'Author Productivity vs Impact';
    }
  }

  // 1. Publication Trend Tab (Line Chart)
  Widget _buildPublicationsTrendTab(SearchProvider provider) {
    final data = provider.yearlyTrends.where((d) {
      final y = int.tryParse(d.label);
      return y != null && y >= 2000 && y <= DateTime.now().year + 1;
    }).toList();

    if (data.isEmpty) {
      return const Center(child: Text('No yearly trend data available.', style: TextStyle(color: Colors.white70)));
    }

    final double maxY = (data.map((d) => d.count).reduce((a, b) => a > b ? a : b) * 1.2).toDouble();
    final years = data.map((d) => int.parse(d.label)).toList();
    final double minX = years.reduce((a, b) => a < b ? a : b).toDouble();
    final double maxX = years.reduce((a, b) => a > b ? a : b).toDouble();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Publications per Year',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Tracking the growth of academic output over time',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'Year ${spot.x.toInt()}: ${spot.y.toInt()} pubs',
                              GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: minX,
                    maxX: maxX,
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: data.map((d) {
                          final y = int.parse(d.label).toDouble();
                          return FlSpot(y, d.count.toDouble());
                        }).toList(),
                        isCurved: true,
                        color: Colors.tealAccent,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.tealAccent.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Top Authors Tab (Bar Chart)
  Widget _buildTopAuthorsTab(SearchProvider provider) {
    final data = provider.topAuthors.take(8).toList();

    if (data.isEmpty) {
      return const Center(child: Text('No authors data available.', style: TextStyle(color: Colors.white70)));
    }

    final double maxY = (data.map((d) => d.count).reduce((a, b) => a > b ? a : b) * 1.2).toDouble();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Contributing Authors',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Ranking authors by number of publications in this area',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int idx = value.toInt();
                            if (idx >= 0 && idx < data.length) {
                              String name = data[idx].label;
                              if (name.contains(',')) {
                                name = name.split(',')[0];
                              } else if (name.split(' ').length > 2) {
                                name = name.split(' ').last;
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Text(
                                    name,
                                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          reservedSize: 40,
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${data[group.x.toInt()].label}\n${rod.toY.toInt()} papers',
                            GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    barGroups: data.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.count.toDouble(),
                            gradient: const LinearGradient(
                              colors: [Colors.indigoAccent, Colors.purpleAccent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Journal Shares Tab (Donut Chart)
  Widget _buildJournalSharesTab(SearchProvider provider) {
    final rawData = provider.topJournals.take(5).toList();
    if (rawData.isEmpty) {
      return const Center(child: Text('No journal data available.', style: TextStyle(color: Colors.white70)));
    }

    final colors = [
      Colors.indigoAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journal Distribution',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Distribution of articles across leading scientific venues',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 50,
                          sections: rawData.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final val = entry.value;
                            return PieChartSectionData(
                              color: colors[idx % colors.length],
                              value: val.count.toDouble(),
                              title: '${val.count}',
                              radius: 40,
                              titleStyle: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rawData.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final val = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: colors[idx % colors.length],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    val.label,
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Author Productivity vs Impact Tab (Scatter Plot using native ScatterChart)
  Widget _buildAuthorProductivityTab(SearchProvider provider) {
    final points = provider.authorImpactPoints;

    if (points.isEmpty) {
      return const Center(child: Text('No productivity vs impact data available.', style: TextStyle(color: Colors.white70)));
    }

    final double maxX = (points.map((p) => p.paperCount).reduce((a, b) => a > b ? a : b) + 1).toDouble();
    final double maxY = (points.map((p) => p.totalCitations).reduce((a, b) => a > b ? a : b) * 1.1).toDouble();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Author Productivity vs Impact',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'Scatter plot mapping Paper Count (X) to Citation Sum (Y)',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ScatterChart(
                  ScatterChartData(
                    gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05)),
                      getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05)),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${value.toInt()} pub(s)',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: maxX,
                    minY: 0,
                    maxY: maxY,
                    scatterTouchData: ScatterTouchData(
                      touchTooltipData: ScatterTouchTooltipData(
                        getTooltipItems: (touchedSpot) {
                          // Find all authors at this exact coordinate to handle overlap
                          final matching = points.where((p) =>
                              p.paperCount == touchedSpot.x.toInt() &&
                              p.totalCitations == touchedSpot.y.toInt()).toList();
                          if (matching.isNotEmpty) {
                            final names = matching.map((p) => p.authorName).join('\n');
                            return ScatterTooltipItem(
                              '$names\n${touchedSpot.x.toInt()} paper(s), ${touchedSpot.y.toInt()} citation(s)',
                              textStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    scatterSpots: points.map((p) {
                      return ScatterSpot(
                        p.paperCount.toDouble(),
                        p.totalCitations.toDouble(),
                        dotPainter: FlDotCirclePainter(
                          radius: 6,
                          color: Colors.yellowAccent,
                          strokeWidth: 1.5,
                          strokeColor: Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
