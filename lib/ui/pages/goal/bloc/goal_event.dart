import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';

sealed class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class AddGoalEvent extends GoalEvent {
  const AddGoalEvent({
    required this.goal,
  });

  final Goal goal;

  @override
  List<Object?> get props {
    return [
      goal,
    ];
  }
}

final class ChangeDateRangeGoalEvent extends GoalEvent {
  const ChangeDateRangeGoalEvent({
    required this.endDate,
    required this.startDate,
  });

  final DateTime endDate;
  final DateTime startDate;

  @override
  List<Object?> get props {
    return [
      endDate,
      startDate,
    ];
  }
}

final class InitialGoalEvent extends GoalEvent {
  const InitialGoalEvent();
}

final class UpdateGoalEvent extends GoalEvent {
  const UpdateGoalEvent({
    required this.goal,
  });

  final Goal goal;

  @override
  List<Object?> get props {
    return [
      goal,
    ];
  }
}

final class UpdateListGoalEvent extends GoalEvent {
  const UpdateListGoalEvent({
    required this.eitherGoals,
  });

  final Either<Failure, List<Goal>> eitherGoals;

  @override
  List<Object?> get props {
    return [
      eitherGoals,
    ];
  }
}
