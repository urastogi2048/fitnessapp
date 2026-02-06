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
  List<FlSpot> monthlyDaywisespots(MonthlyDaywise data) {
      List<FlSpot> spots = [];
      for (int i = 0; i < data.date.length; i++) {
        final x = i.toDouble();
        final y = data.totalMinutes[i].toDouble();
        spots.add(FlSpot(x, y));
      }
      return spots;
    }

    List<BarChartGroupData> weeklyDaywisebarGroups(MonthlyDaywise data1){
        List<BarChartGroupData> bar= [];
        for(int i=23; i<30 ;i++){
            //final x= i;
            final y= data1.totalMinutes[i].toDouble();
            bar.add( BarChartGroupData(
              x: i,
              barRods: [BarChartRodData( toY: y,  width: 15, color: i%2 ==0 ?  const Color.fromARGB(255, 11, 88, 221) : Colors.lightBlueAccent,)]

            ));
        }
        return bar;
    }
    List<BarChartGroupData> weeklybodypartwisebargroups(WeeklyBodyPartwise data2){
      List<BarChartGroupData> bar=[];
      for(int i=0; i<data2.bodyPart.length; i++){
          final y= data2.totalMinutes[i].toDouble();
          bar.add(BarChartGroupData (x: i, 
            barRods: [BarChartRodData(toY: y, width: 15, color:  data2.bodyPart[i]=='chest' ? Colors.lightBlue[200] : data2.bodyPart[i]=='back' ? Colors.blue[150] : data2.bodyPart[i]=='core' ? Colors.blue[250] : data2.bodyPart[i]=='cardio' ? Colors.blue[300] : data2.bodyPart[i]=='legs' ? Colors.blue[400] : data2.bodyPart[i]=='arms' ? Colors.blueAccent :  Colors.blue[800],)]
          ));
      }
      return bar;
    }
    List<PieChartSectionData> bodypartwisepiechartsections(MonthlyBodyPartwise data3){
      List<PieChartSectionData> pie= [];
      for(int i=0; i<data3.bodyPart.length; i++) {
          // value: data3.percentage[i].toDouble();
          // title: data3.bodyPart[i];
          // radius: 50;
          pie.add(PieChartSectionData(
            value:data3.percentage[i].toDouble(),
            title: '${data3.percentage[i].toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            color: data3.bodyPart[i]=='chest' ? Colors.lightBlue[200] : data3.bodyPart[i]=='back' ? Colors.blue[150] : data3.bodyPart[i]=='core' ? Colors.lightBlue: data3.bodyPart[i]=='cardio' ? Colors.blue[300] : data3.bodyPart[i]=='legs' ? Colors.blue[400] : data3.bodyPart[i]=='arms' ? Colors.blueAccent : Colors.blue[800],
          ));
      }
      return pie; 
    }
  @override
  Widget build(BuildContext context) {
    

    final monthlyAsync = ref.watch(monthlyDaywiseProvider);
    //final WeeklyDaywiseAsync = ref.watch(weeklyDaywiseProvider);
    final weeklybodypartwiseasync = ref.watch(weeklyBodyPartwiseProvider);
    final monthlyBodyPartwiseasync = ref.watch(monthlyBodyPartwiseProvider);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Progress Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Track your fitness journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(height: 20.0),
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
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                            
                              getTitlesWidget: (value, meta) => Text(
                                monthlyData.date[value.toInt()].substring(5, 10),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                ),
                              ),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                            
                              getTitlesWidget: (value, meta) {
                               if(value<10){
                                    return Text(
                                  value.toDouble().toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontFamily: GoogleFonts.manrope().fontFamily,
                                  ),
                                );}
                              else {
                               return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
                                ),
                              );}
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
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const  Color.fromARGB(255, 8, 13, 30),
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
                height : 300,
                width: double.infinity,
                child: monthlyAsync.when(
                  data: (weeklydaywisedata) => 
                  BarChart(
                    BarChartData(
                      barGroups: weeklyDaywisebarGroups(weeklydaywisedata),
                        titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => Text(
                              weeklydaywisedata.date[value.toInt()].substring(5,10),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: GoogleFonts.manrope().fontFamily,
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
                                fontFamily: GoogleFonts.manrope().fontFamily,
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
                    loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
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
                  height : 300,
                  width: double.infinity,
                  child: weeklybodypartwiseasync.when(
                    data: (data2)=> BarChart(
                      BarChartData(
                        barGroups: weeklybodypartwisebargroups(data2),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                 data2.bodyPart[value.toInt()],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: GoogleFonts.manrope().fontFamily,
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
                                  fontFamily: GoogleFonts.manrope().fontFamily,
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
                
                      loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
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
                        sections: bodypartwisepiechartsections(monthlybodypartwisedata),
                      ),
                
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                
                  ),
                ),
                const SizedBox(height: 20),
                monthlyBodyPartwiseasync.when(
                  data: (data) => Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: List.generate(data.bodyPart.length, (i) {
                      final color = data.bodyPart[i]=='chest' ? Colors.lightBlue[200] : data.bodyPart[i]=='back' ? Colors.blue[200] : data.bodyPart[i]=='core' ? Colors.lightBlue: data.bodyPart[i]=='cardio' ? Colors.blue[300] : data.bodyPart[i]=='legs' ? Colors.blue[400] : data.bodyPart[i]=='arms' ? Colors.blueAccent : Colors.blue[800];
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
                              fontFamily: GoogleFonts.manrope().fontFamily,
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
