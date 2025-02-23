import 'package:equatable/equatable.dart';
import 'package:track_my_money/ui/pages/dashboard/models/transaction_trend_model.dart';

final class DashboardState extends Equatable {
  const DashboardState({
    this.transactionSummaryTypes = const <TransactionTrendModel>[],
    this.transactionTrends = const <TransactionTrendModel>[],
  });

  final List<TransactionTrendModel> transactionSummaryTypes;
  final List<TransactionTrendModel> transactionTrends;

  @override
  List<Object?> get props {
    return [
      transactionSummaryTypes,
      transactionTrends,
    ];
  }

  DashboardState copyWith({
    List<TransactionTrendModel>? transactionSummaryTypes,
    List<TransactionTrendModel>? transactionTrends,
  }) {
    return DashboardState(
      transactionSummaryTypes:
          transactionSummaryTypes ?? this.transactionSummaryTypes,
      transactionTrends: transactionTrends ?? this.transactionTrends,
    );
  }
}
