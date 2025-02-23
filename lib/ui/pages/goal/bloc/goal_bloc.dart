import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/goal/application/goal_service.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_event.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc({
    required this.goalService,
  }) : super(
          GoalState(
            endDate: DateTime.now().add(const Duration(days: 31)),
            startDate: DateTime.now(),
          ),
        ) {
    log('GoalBloc created', name: 'Bloc');
    on<AddGoalEvent>(_onAddGoalEvent);
    on<ChangeDateRangeGoalEvent>(_onChangeDateRangeGoalEvent);
    on<InitialGoalEvent>(_onInitialGoalEvent);
    on<UpdateGoalEvent>(_onUpdateGoalEvent);
    on<UpdateListGoalEvent>(_onUpdateListGoalEvent);
    add(const InitialGoalEvent());
  }

  final GoalService goalService;
  StreamSubscription<Either<Failure, List<Goal>>>? _goalSubscription;

  @override
  Future<void> close() {
    _goalSubscription?.cancel();
    log('GoalBloc closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _onAddGoalEvent(
    AddGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    String error = '';
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          error: error,
          isLoading: true,
        ),
      );
      final Either<Failure, Goal> eitherGoal =
          await goalService.create(event.goal);
      eitherGoal.fold(
        (failure) {
          error = failure.code;
        },
        (data) {},
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            error: error,
            isLoading: false,
          ),
        );
      }
    }
  }

  Future<void> _onChangeDateRangeGoalEvent(
    ChangeDateRangeGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(
      state.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        isLoading: true,
        error: '',
      ),
    );
    await _subscribeToStream(
      endDate: state.endDate,
      startDate: state.startDate,
    );
    emit(
      state.copyWith(
        isLoading: false,
      ),
    );
  }

  Future<void> _onInitialGoalEvent(
    InitialGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    if (isClosed) return;
    await _subscribeToStream(
      endDate: state.endDate,
      startDate: state.startDate,
    );
  }

  Future<void> _onUpdateGoalEvent(
    UpdateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    String error = '';
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          error: error,
          isLoading: true,
        ),
      );
      final Either<Failure, Goal> eitherGoal =
          await goalService.update(event.goal);
      eitherGoal.fold(
        (failure) {
          error = failure.code;
        },
        (data) {},
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            error: error,
            isLoading: false,
          ),
        );
      }
    }
  }

  Future<void> _onUpdateListGoalEvent(
    UpdateListGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    final List<Goal> goals = [];
    String error = '';
    event.eitherGoals.fold(
      (failure) {
        error = failure.code;
      },
      (data) {
        goals.addAll(data);
      },
    );
    emit(state.copyWith(goals: goals, error: error));
  }

  Future<void> _subscribeToStream({
    required DateTime endDate,
    required DateTime startDate,
  }) async {
    await _goalSubscription?.cancel();
    _goalSubscription = goalService
        .getByDateRangeStream(startDate: startDate, endDate: endDate)
        .listen(
      (eitherGoals) {
        add(UpdateListGoalEvent(eitherGoals: eitherGoals));
      },
    );
  }
}
