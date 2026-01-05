import 'package:flutter/material.dart';
import 'package:frontendd/features/auth/qstate.dart';
class UserState {
  final String Username;
  final String Email;
  final Qstate qstate;
  int streak;
  UserState({
    required this.Username,
    required this.Email,
    required this.qstate,
    this.streak = 0,
  });
  UserState copyWith({
    String? username,
    String? email,
    int? streak,
    Qstate? qstate,
  }) {
    return UserState(
      Username: username ?? this.Username,
      Email: email ?? this.Email,
      streak: streak ?? this.streak,
      qstate: qstate ?? this.qstate,
    );
  }

}