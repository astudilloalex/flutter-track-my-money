import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';

final class GoalState extends Equatable {
  const GoalState({
    required this.endDate,
    this.error = '',
    this.goals = const <Goal>[],
    this.isLoading = false,
    required this.startDate,
  });

  final DateTime endDate;
  final String error;
  final List<Goal> goals;
  final bool isLoading;
  final DateTime startDate;

  @override
  List<Object?> get props {
    return [
      endDate,
      error,
      goals,
      isLoading,
      startDate,
    ];
  }

  GoalState copyWith({
    DateTime? endDate,
    String? error,
    List<Goal>? goals,
    bool? isLoading,
    DateTime? startDate,
  }) {
    return GoalState(
      endDate: endDate ?? this.endDate,
      error: error ?? this.error,
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
    );
  }
}
