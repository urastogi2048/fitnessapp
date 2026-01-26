import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:frontendd/features/home/streakservice.dart';
import 'package:frontendd/services/apiservices.dart';
import 'package:frontendd/core/tokenstorage.dart';
import 'statmodels.dart';
final statsServiceProvider = Provider<StatsService>((ref ) {
  return StatsService(ApiService());
});

final weeklyDaywiseProvider = FutureProvider.autoDispose<WeeklyDaywise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getWeeklyDaywise(  token);

});

final weeklyBodyPartwiseProvider = FutureProvider.autoDispose<WeeklyBodyPartwise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getWeeklyBodyPartwise(token);

});

final monthlyDaywiseProvider = FutureProvider.autoDispose<MonthlyDaywise>((ref) async {
  final service = ref.read(statsServiceProvider);
  final token = await TokenStorage.getToken();
  if(token==null) throw Exception ('No token');
  return service.getMonthlyDaywise(token);
});

final monthlyBodyPartwiseProvider = FutureProvider.autoDispose<MonthlyBodyPartwise> ((ref) async {
  final service =ref.read(statsServiceProvider);
  final token=await TokenStorage.getToken();
  if(token==null) throw Exception('No token');
  return service.getMonthlyBodyPartwise(token);
});