import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class ChangeTransactionDashboardEvent extends DashboardEvent {
  const ChangeTransactionDashboardEvent({
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  List<Object?> get props {
    return [transactions];
  }
}

final class InitDashboardEvent extends DashboardEvent {
  const InitDashboardEvent();
}
