
import 'package:frontendd/services/apiservices.dart';

class WeeklyDaywise {
  final List<String> day;
  final List<int> totalSeconds;
  final List<int> totalMinutes;
  WeeklyDaywise({
    required this.day,
    required this.totalSeconds,
    required this.totalMinutes,


  });
  factory WeeklyDaywise.fromJson(List< dynamic> jsonList) {
     List<String> day=[];
        List<int> totalSeconds=[];
        List<int> totalMinutes=[];
        for (var i in jsonList){
            day.add(i['day']);
            totalSeconds.add(i['totalSeconds']);
            totalMinutes.add(i['totalMinutes']);
        }
     return WeeklyDaywise (
        day: day,
        totalSeconds: totalSeconds,
        totalMinutes: totalMinutes,
     );
  }


}
class WeeklyBodyPartwise {
    final List<String> bodyPart;
    final List<int> totalSeconds;
    final List<int> totalMinutes;
    WeeklyBodyPartwise({
      required this.bodyPart,
      required this.totalSeconds,
      required this.totalMinutes,
    });
    factory WeeklyBodyPartwise.fromJson(   List<dynamic> jsonList){
        List<String > bodyPart=[];
        List<int> totalSeconds=[];
        List<int> totalMinutes=[];

        for(var i in jsonList)  {
            bodyPart.add(i['bodyPart']);
            totalSeconds.add(i['totalSeconds']);
            totalMinutes.add(i['totalMinutes']);
        }
        return WeeklyBodyPartwise(
            bodyPart: bodyPart,
            totalSeconds: totalSeconds, 
            totalMinutes: totalMinutes,

        );
    }
}
class MonthlyDaywise {
  final List<String> date;
  final List<int> totalSeconds;
  final List<int> totalMinutes;
  MonthlyDaywise({
    required this.date,
    required this.totalSeconds,
    required this.totalMinutes,
  });
  factory MonthlyDaywise.fromJson(List< dynamic> jsonList) {
        List<String> date=[];
            List<int> totalSeconds=[];
            List<int> totalMinutes=[];
            for (var i in jsonList){
                date.add(i['date']);
                totalSeconds.add(i['totalSeconds']);
                totalMinutes.add(i['totalMinutes']);
            }
     return MonthlyDaywise (
        date: date,
        totalSeconds: totalSeconds,
        totalMinutes: totalMinutes,
     );
  }
}
class MonthlyBodyPartwise {
  final List<String> bodyPart;
  final List<int> totalSeconds;
  final List<int> totalMinutes;
  final List<double> percentage;
  MonthlyBodyPartwise({
    required this.bodyPart,
    required this.totalSeconds,
    required this.totalMinutes,
    required this.percentage,
  });
    factory MonthlyBodyPartwise.fromJson(List<dynamic> jsonList) {
        List<String> bodyPart=[];
        List<int> totalSeconds=[];
        List<int> totalMinutes=[];
        List<double> percentage=[];
        for (var i in jsonList){
            bodyPart.add(i['bodyPart']);
            totalSeconds.add(i['totalSeconds']);
            totalMinutes.add(i['totalMinutes']);
          percentage.add(double.tryParse(i['percentage'].toString()) ?? 0.0);
        }
         return MonthlyBodyPartwise (
            bodyPart: bodyPart,
            totalSeconds: totalSeconds,
            totalMinutes: totalMinutes,
            percentage: percentage,
         );
    }
}

class StatsService {
    final ApiService api;
    StatsService(this.api);

    Future<WeeklyDaywise> getWeeklyDaywise(String token) async {
        final data = await api.get('/workout/stats/weekly-daywise', token : token);
        return WeeklyDaywise.fromJson(data as List);
        

    }
    Future<WeeklyBodyPartwise> getWeeklyBodyPartwise(String token) async {
        final data = await api.get('/workout/stats/weekly-bodypart', token : token);
        return WeeklyBodyPartwise.fromJson(data as List);
    }
    Future<MonthlyDaywise> getMonthlyDaywise(String token) async {
        final data = await api.get('/workout/stats/growth-30day', token : token);
        return MonthlyDaywise.fromJson(data as List);
    }
    Future<MonthlyBodyPartwise> getMonthlyBodyPartwise(String token) async {
        final data = await api.get('/workout/stats/bodypart-distribution', token : token);
        return MonthlyBodyPartwise.fromJson(data as List);
    }
}