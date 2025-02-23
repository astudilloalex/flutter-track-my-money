import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class ChangeDateRangeHomeEvent extends HomeEvent {
  const ChangeDateRangeHomeEvent({
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

final class InitialHomeEvent extends HomeEvent {
  const InitialHomeEvent();
}

final class TabChangedHomeEvent extends HomeEvent {
  const TabChangedHomeEvent(this.tabIndex);

  final int tabIndex;

  @override
  List<Object?> get props {
    return [
      tabIndex,
    ];
  }
}

final class LoadCategoryHomeEvent extends HomeEvent {
  const LoadCategoryHomeEvent();
}

final class AddTransactionHomeEvent extends HomeEvent {
  const AddTransactionHomeEvent({
    required this.transaction,
  });

  final Transaction transaction;

  @override
  List<Object?> get props {
    return [
      transaction,
    ];
  }
}
