import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendd/components/custom_app_header.dart';
import 'package:frontendd/features/progress/statmodels.dart';
import 'package:frontendd/features/progress/statprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
class StatsUI extends ConsumerStatefulWidget {
  const StatsUI({Key? key}) : super(key: key);

  @override
  ConsumerState<StatsUI> createState() => _StatsUIState();
}

class _StatsUIState extends ConsumerState<StatsUI> {
  List<FlSpot> monthlyDaywisespots(MonthlyDaywise data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.date.length; i++) {
      final x = i.toDouble();
      final y = data.totalMinutes[i].toDouble();
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  List<BarChartGroupData> weeklyDaywisebarGroups(MonthlyDaywise data1) {
    List<BarChartGroupData> bar = [];
    for (int i = 23; i < 30; i++) {
      //final x= i;
      final y = data1.totalMinutes[i].toDouble();
      bar.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              width: 15,
              color: i % 2 == 0
                  ? const Color.fromARGB(255, 11, 88, 221)
                  : Colors.lightBlueAccent,
            ),
          ],
        ),
      );
    }
    return bar;
  }

  List<BarChartGroupData> weeklybodypartwisebargroups(
    WeeklyBodyPartwise data2,
  ) {
    List<BarChartGroupData> bar = [];
    for (int i = 0; i < data2.bodyPart.length; i++) {
      final y = data2.totalMinutes[i].toDouble();
      bar.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: y,
              width: 15,
              color: data2.bodyPart[i] == 'chest'
                  ? Colors.lightBlue[200]
                  : data2.bodyPart[i] == 'back'
                  ? Colors.blue[150]
                  : data2.bodyPart[i] == 'core'
                  ? Colors.blue[250]
                  : data2.bodyPart[i] == 'cardio'
                  ? Colors.blue[300]
                  : data2.bodyPart[i] == 'legs'
                  ? Colors.blue[400]
                  : data2.bodyPart[i] == 'arms'
                  ? Colors.blueAccent
                  : Colors.blue[800],
            ),
          ],
        ),
      );
    }
    return bar;
  }

  List<PieChartSectionData> bodypartwisepiechartsections(
    MonthlyBodyPartwise data3,
  ) {
    List<PieChartSectionData> pie = [];
    for (int i = 0; i < data3.bodyPart.length; i++) {
      // value: data3.percentage[i].toDouble();
      // title: data3.bodyPart[i];
      // radius: 50;
      pie.add(
        PieChartSectionData(
          value: data3.percentage[i].toDouble(),
          title: '${data3.percentage[i].toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          color: data3.bodyPart[i] == 'chest'
              ? Colors.lightBlue[200]
              : data3.bodyPart[i] == 'back'
              ? Colors.blue[150]
              : data3.bodyPart[i] == 'core'
              ? Colors.lightBlue
              : data3.bodyPart[i] == 'cardio'
              ? Colors.blue[300]
              : data3.bodyPart[i] == 'legs'
              ? Colors.blue[400]
              : data3.bodyPart[i] == 'arms'
              ? Colors.blueAccent
              : Colors.blue[800],
        ),
      );
    }
    return pie;
  }

  @override
  Widget build(BuildContext context) {
    final monthlyAsync = ref.watch(monthlyDaywiseProvider);
    //final WeeklyDaywiseAsync = ref.watch(weeklyDaywiseProvider);
    final weeklybodypartwiseasync = ref.watch(weeklyBodyPartwiseProvider);
    final monthlyBodyPartwiseasync = ref.watch(monthlyBodyPartwiseProvider);
    final heatmapDataasync=ref.watch(heatmapDataProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25.0.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppHeader(
                  backLabel: 'Home',
                  title: 'Progress Dashboard',
                ),
                SizedBox(height: 10.h),
                Text(
                  'Track your fitness journey',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                SizedBox(height: 10.h),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'HEATMAP',
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color.fromARGB(172, 0, 243, 12),
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.solidCalendarDays,
                                size: 40,
                                color: const Color.fromARGB(255, 0, 243, 12).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'DayWise Activity Heatmap',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 270.h,
                          width: double.infinity,
                          child: heatmapDataasync.when(
                            data: (heatmapdata) => _CustomHeatmap(heatmapdata: heatmapdata),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, s) => Center(child: Text('Error: $e')),
                          ),
                        ),
                       // const SizedBox(height: 20),
                        
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MONTHLY ACTIVITY',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.lightBlueAccent,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.chartLine,
                                size: 40,
                                color: Colors.lightBlueAccent.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Last 30 Days (Minutes)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: monthlyAsync.when(
                            data: (monthlyData) => LineChart(
                              LineChartData(
                                minY: 0,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) => Transform.rotate(
                                        angle: 0.785,
                                        child: Text(
                                          monthlyData.date[value.toInt()]
                                              .substring(5, 10),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontFamily:
                                                GoogleFonts.manrope().fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,

                                      getTitlesWidget: (value, meta) {
                                        if (value < 10) {
                                          return Text(
                                            value.toDouble().toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: GoogleFonts.manrope()
                                                  .fontFamily,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontFamily: GoogleFonts.manrope()
                                                  .fontFamily,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: monthlyDaywisespots(monthlyData),
                                    isCurved: true,
                                    preventCurveOverShooting: true,
                                    dotData: FlDotData(show: false),
                                    //belowBarData: BarAreaData(show: false),
                                    barWidth: 3,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.lightBlueAccent,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'WEEKLY ACTIVITY',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.chartBar,
                                size: 40,
                                color: Colors.blueAccent.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Last 7 Days (Minutes)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: monthlyAsync.when(
                            data: (weeklydaywisedata) => BarChart(
                              BarChartData(
                                barGroups: weeklyDaywisebarGroups(
                                  weeklydaywisedata,
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, meta) => Transform.rotate(
                                        angle: 0.785,
                                        child: Text(
                                          weeklydaywisedata.date[value.toInt()]
                                              .substring(5, 10),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontFamily:
                                                GoogleFonts.manrope().fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) => Text(
                                        value.toDouble().toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily:
                                              GoogleFonts.manrope().fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'BODY PART FOCUS',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.orange,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.dumbbell,
                                size: 40,
                                color: Colors.orange.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Weekly Body Part (Minutes)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: weeklybodypartwiseasync.when(
                            data: (data2) => BarChart(
                              BarChartData(
                                barGroups: weeklybodypartwisebargroups(data2),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 45,
                                      getTitlesWidget: (value, meta) => Transform.rotate(
                                        angle: 0.785,
                                        child: Text(
                                          data2.bodyPart[value.toInt()],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                            fontFamily:
                                                GoogleFonts.manrope().fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) => Text(
                                        value.toDouble().toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily:
                                              GoogleFonts.manrope().fontFamily,
                                        ),
                                      ),
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                              ),
                            ),

                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MONTHLY DISTRIBUTION',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.purpleAccent,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                FontAwesomeIcons.chartPie,
                                size: 40,
                                color: Colors.purpleAccent.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          'Body Part Distribution',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: monthlyBodyPartwiseasync.when(
                            data: (monthlybodypartwisedata) => PieChart(
                              PieChartData(
                                sections: bodypartwisepiechartsections(
                                  monthlybodypartwisedata,
                                ),
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) =>
                                Center(child: Text('Error: $error')),
                          ),
                        ),
                        const SizedBox(height: 20),
                        monthlyBodyPartwiseasync.when(
                          data: (data) => Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: List.generate(data.bodyPart.length, (i) {
                              final color = data.bodyPart[i] == 'chest'
                                  ? Colors.lightBlue[200]
                                  : data.bodyPart[i] == 'back'
                                  ? Colors.blue[200]
                                  : data.bodyPart[i] == 'core'
                                  ? Colors.lightBlue
                                  : data.bodyPart[i] == 'cardio'
                                  ? Colors.blue[300]
                                  : data.bodyPart[i] == 'legs'
                                  ? Colors.blue[400]
                                  : data.bodyPart[i] == 'arms'
                                  ? Colors.blueAccent
                                  : Colors.blue[800];
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${data.bodyPart[i]} (${data.percentage[i].toStringAsFixed(1)}%)',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontFamily:
                                          GoogleFonts.manrope().fontFamily,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─── paste anywhere in your file, outside the State class ───────────────────

class _CustomHeatmap extends StatefulWidget {
  final HeatMapData heatmapdata;
  const _CustomHeatmap({required this.heatmapdata});

  @override
  State<_CustomHeatmap> createState() => _CustomHeatmapState();
}

class _CustomHeatmapState extends State<_CustomHeatmap> {
  int _windowIndex = 0; // 0 = most recent 90 days, 1 = 91-180, etc.

  static const int _windowSize = 90;
  static const List<String> _windowLabels = [
    'Last 0–90 days',
    'Last 91–180 days',
    'Last 181–270 days',
    'Last 271–360 days',
  ];

  // Build date → seconds map from provider data
  Map<DateTime, int> get _valueByDate {
    final map = <DateTime, int>{};
    for (int i = 0; i < widget.heatmapdata.date.length; i++) {
      final d = widget.heatmapdata.date[i];
      map[DateTime(d.year, d.month, d.day)] = widget.heatmapdata.totalSeconds[i];
    }
    return map;
  }

  // Returns the start and end dates for the selected 90-day window.
  // _windowIndex 0  → today-0   .. today-89   (most recent)
  // _windowIndex 1  → today-90  .. today-179
  // _windowIndex 2  → today-180 .. today-269
  // _windowIndex 3  → today-270 .. today-359
  (DateTime start, DateTime end) get _windowDates {
    final today = DateTime.now();
    final base  = DateTime(today.year, today.month, today.day);
    final endDate   = base.subtract(Duration(days: _windowIndex * _windowSize));
    final startDate = base.subtract(Duration(days: _windowIndex * _windowSize + _windowSize - 1));
    return (startDate, endDate);
  }

  Color _colorForSeconds(int seconds) {
    if (seconds <= 0)   return const Color.fromARGB(255, 41, 41, 41); // empty cell
    if (seconds < 600) return const Color.fromARGB(80,  0, 243, 12);
    if (seconds < 2400) return const Color.fromARGB(130, 0, 243, 12);
    if (seconds < 3600) return const Color.fromARGB(180, 0, 243, 12);
    if (seconds < 5400) return const Color.fromARGB(220, 0, 243, 12);
    return const Color.fromARGB(255, 0, 243, 12);
  }

  String _formatSeconds(int s) {
    if (s <= 0) return 'Rest day';
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final (startDate, endDate) = _windowDates;
    final valueByDate = _valueByDate;

    // Collect all Monday-of-week anchors for the window
    final weekStarts = <DateTime>[];
    final seen = <int>{};
    var cursor = startDate;
    while (!cursor.isAfter(endDate)) {
      final monday = cursor.subtract(Duration(days: cursor.weekday - 1));
      final normMonday = DateTime(monday.year, monday.month, monday.day);
      if (seen.add(normMonday.millisecondsSinceEpoch)) {
        weekStarts.add(normMonday);
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    // Build a grid: rows = Mon–Sun (7), cols = each week
    // grid[col][row] = DateTime (may be null if outside window)
    final grid = List.generate(weekStarts.length, (col) {
      return List.generate(7, (row) {
        final d = weekStarts[col].add(Duration(days: row));
        if (d.isBefore(startDate) || d.isAfter(endDate)) return null;
        return d;
      });
    });

    const double cellSize  = 15.0;
    const double cellGap   = 3.0;
    const double labelH    = 18.0;
    const double yLabelW   = 28.0;
    const List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Month labels: find first col per month
    final monthLabels = <int, String>{};
    for (int col = 0; col < weekStarts.length; col++) {
      for (int row = 0; row < 7; row++) {
        final d = grid[col][row];
        if (d != null) {
          final key = col;
          if (!monthLabels.containsKey(key)) {
            // only show if it's the 1st occurrence of this month
            final prev = col > 0 ? grid[col - 1].firstWhere((x) => x != null, orElse: () => null) : null;
            if (prev == null || prev.month != d.month) {
              monthLabels[col] = _monthAbbr(d.month);
            }
          }
          break;
        }
      }
    }

    final totalW = yLabelW + weekStarts.length * (cellSize + cellGap);
    final totalH = labelH + 7 * (cellSize + cellGap);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dropdown ─────────────────────────────────────────────────────────
        PopupMenuButton<int>(
          initialValue: _windowIndex,
          color: const Color(0xFF0E1A0E),
          onSelected: (v) => setState(() => _windowIndex = v),
          itemBuilder: (_) => List.generate(4, (i) => PopupMenuItem(
            value: i,
            child: Text(
              _windowLabels[i],
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          )),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(80, 0, 243, 12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color.fromARGB(100, 0, 243, 12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _windowLabels[_windowIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Colors.white70),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Heatmap grid ─────────────────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalW,
            height: totalH,
            child: Stack(
              children: [
                // Month labels row
                ...monthLabels.entries.map((e) {
                  final x = yLabelW + e.key * (cellSize + cellGap);
                  return Positioned(
                    left: x,
                    top: 0,
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  );
                }),

                // Day-of-week labels (Mon..Sun)
                ...List.generate(7, (row) => Positioned(
                  left: 0,
                  top: labelH + row * (cellSize + cellGap) + (cellSize - 11) / 2,
                  child: SizedBox(
                    width: yLabelW - 4,
                    child: Text(
                      // only show M, W, F to keep it compact
                      (row == 0 || row == 2 || row == 4)
                          ? dayLabels[row]
                          : '',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )),

                // Cells
                ...List.generate(weekStarts.length, (col) {
                  return List.generate(7, (row) {
                    final date = grid[col][row];
                    if (date == null) return const SizedBox.shrink();
                    final secs = valueByDate[date] ?? 0;
                    final color = _colorForSeconds(secs);
                    final x = yLabelW + col * (cellSize + cellGap);
                    final y = labelH + row * (cellSize + cellGap);

                    return Positioned(
                      left: x,
                      top: y,
                      child: Tooltip(
                        message:
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}  ${_formatSeconds(secs)}',
                        preferBelow: false,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1A0E),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: const Color.fromARGB(80, 0, 243, 12)),
                        ),
                        textStyle: const TextStyle(
                            color: Colors.white70, fontSize: 11),
                        child: Container(
                          width: cellSize,
                          height: cellSize,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                      ),
                    );
                  });
                }).expand((list) => list),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── Legend ────────────────────────────────────────────────────────────
        Row(
          children: [
            const Text('Less',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
            const SizedBox(width: 6),
            ...[0, 600, 2400, 3600, 5400].map((s) => Container(
                  width: 11,
                  height: 11,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: _colorForSeconds(s),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )),
            const SizedBox(width: 3),
            const Text('More',
                style: TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return months[month - 1];
  }
}