import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  @override
  Widget build(BuildContext context) {
    
    List <FlSpot> monthlyDaywisespots (MonthlyDaywise data) {
  List<FlSpot> spots=[];
  for (int i=0; i< data.date.length; i++){
    final x= i.toDouble();
    final y=data.totalMinutes[i].toDouble();
    spots.add(FlSpot(x, y));
  }
  return spots;
}
final monthlyAsync = ref.watch(monthlyDaywiseProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.grey,
                    size: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Progress Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
                      const SizedBox(height: 25),
                       
             SizedBox(
               height: 300,
               width: double.infinity,
               child: monthlyAsync.when(
                 data: (monthlyData) => LineChart(
                   LineChartData(
                     lineBarsData: [
                       LineChartBarData(
                         spots: monthlyDaywisespots(monthlyData),
                         isCurved: true,
                       ),
                     ],
                   ),
                 ),
                 loading: () => const Center(child: CircularProgressIndicator()),
                 error: (error, stack) => Center(child: Text('Error: $error')),
               ),
             ),
          ],
         

        ),
      ),
    );
  }
}
