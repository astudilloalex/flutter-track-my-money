import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart' show compute, kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_event.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_state.dart';
import 'package:track_my_money/ui/pages/dashboard/models/transaction_trend_model.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    this.transactions = const <Transaction>[],
  }) : super(const DashboardState()) {
    log('DashboardBloc created', name: 'Bloc');
    on<ChangeTransactionDashboardEvent>(_onChangeTransactionDashboardEvent);
    on<InitDashboardEvent>(_onInitDashboardEvent);
    add(const InitDashboardEvent());
  }

  final List<Transaction> transactions;

  @override
  Future<void> close() {
    log('Dashboard closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _onInitDashboardEvent(
    InitDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (transactions.isEmpty) return;
    if (kIsWeb) {
      emit(
        state.copyWith(
          transactionTrends: _trasactions(transactions),
          transactionSummaryTypes: _transactionSummaryTypes(transactions),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        transactionTrends: await compute(
          _trasactions,
          transactions,
        ),
        transactionSummaryTypes: await compute(
          _transactionSummaryTypes,
          transactions,
        ),
      ),
    );
  }

  Future<void> _onChangeTransactionDashboardEvent(
    ChangeTransactionDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (kIsWeb) {
      emit(
        state.copyWith(
          transactionTrends: _trasactions(event.transactions),
          transactionSummaryTypes: _transactionSummaryTypes(event.transactions),
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        transactionTrends: await compute(
          _trasactions,
          event.transactions,
        ),
        transactionSummaryTypes: await compute(
          _transactionSummaryTypes,
          event.transactions,
        ),
      ),
    );
  }
}

List<TransactionTrendModel> _transactionSummaryTypes(
  List<Transaction> transactions,
) {
  final List<TransactionTrendModel> transactionTrends = [];
  for (final Transaction transaction in transactions) {
    final TypeEnum type = transaction.type;
    final int index = transactionTrends.indexWhere(
      (element) {
        return element.type == type;
      },
    );
    if (index >= 0) {
      transactionTrends[index] = transactionTrends[index].copyWith(
        amount: (Decimal.parse(transactionTrends[index].amount.toString()) +
                Decimal.parse(transaction.amount.toString()))
            .toDouble(),
      );
    } else {
      transactionTrends.add(
        TransactionTrendModel(
          amount: Decimal.parse(transaction.amount.toString()).toDouble(),
          date: transaction.date,
          type: type,
        ),
      );
    }
  }
  return transactionTrends;
}

List<TransactionTrendModel> _trasactions(List<Transaction> transactions) {
  final List<TransactionTrendModel> transactionTrends = [];
  for (final Transaction transaction in transactions) {
    final DateTime dateTime = transaction.date;
    final int index = transactionTrends.indexWhere(
      (element) =>
          element.date.year == dateTime.year &&
          element.date.month == dateTime.month &&
          element.date.day == dateTime.day &&
          element.type == transaction.type,
    );
    if (index >= 0) {
      transactionTrends[index] = transactionTrends[index].copyWith(
        amount: (Decimal.parse(transactionTrends[index].amount.toString()) +
                Decimal.parse(transaction.amount.toString()))
            .toDouble(),
      );
    } else {
      transactionTrends.add(
        TransactionTrendModel(
          amount: Decimal.parse(transaction.amount.toString()).toDouble(),
          date: transaction.date.copyWith(
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          ),
          type: transaction.type,
        ),
      );
    }
  }
  transactionTrends.sort(
    (a, b) => a.date.compareTo(b.date),
  );
  return transactionTrends;
}
