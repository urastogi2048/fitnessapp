import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:frontendd/features/home/streakservice.dart';
import 'package:frontendd/services/apiservices.dart';
import 'package:frontendd/core/tokenstorage.dart';
import 'statmodels.dart';
final statsServiceProvider = Provider<StatsService>((ref ) {
  return StatsService(ApiService());
});

final weeklyDaywiseprovider= FutureProvider<WeeklyDaywise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getWeeklyDaywise(  token);

});

final weeklyBodyPartwise =FutureProvider<WeeklyBodyPartwise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getWeeklyBodyPartwise(token);

});

final monthlyDaywiseProvider = FutureProvider<MonthlyDaywise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception ('No token');
  return service.getMonthlyDaywise(token);
});

final monthlyBodyPartwiseProvider = FutureProvider<MonthlyBodyPartwise> ((ref) async {
  final service =ref.read(statsServiceProvider);
  final token=await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getMonthlyBodyPartwise(token);
});