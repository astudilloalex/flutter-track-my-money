import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/category/application/category_service.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/transaction/application/transaction_service.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_event.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required this.transactionService,
    required this.categoryService,
  }) : super(
          TransactionState(
            endDate: DateTime.now().copyWith(
              hour: 23,
              minute: 59,
              second: 59,
              millisecond: 999,
              microsecond: 999,
            ),
            startDate: DateTime.now().copyWith(
              hour: 0,
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0,
              day: 1,
            ),
          ),
        ) {
    log('TransactionBloc created', name: 'Bloc');
    on<InitialTransactionEvent>(_onInitialTransactionEvent);
    on<AddTransactionEvent>(_onAddTransactionEvent);
    add(const InitialTransactionEvent());
  }

  final TransactionService transactionService;
  final CategoryService categoryService;

  @override
  Future<void> close() {
    log('TransactionBloc closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _onInitialTransactionEvent(
    InitialTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    List<Category> categories = [];
    List<Transaction> transactions = [];
    String error = '';
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          categories: categories,
          categoryCodes: [],
          error: error,
          isLoading: true,
          transactions: transactions,
          typeIds: [],
        ),
      );
      // Fill categories
      final Either<Failure, List<Category>> eitherCategories =
          await categoryService.getAll(
        onlyActive: true,
      );
      eitherCategories.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          categories = data;
        },
      );
      if (error.isNotEmpty) return;
      // Fill transactions
      final Either<Failure, List<Transaction>> eitherTransactions =
          await transactionService.findByDateRange(
        startDate: state.startDate,
        endDate: state.endDate,
      );
      eitherTransactions.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          transactions = data;
        },
      );
      if (error.isNotEmpty) return;
      for (int i = 0; i < transactions.length; i++) {
        transactions[i] = transactions[i].copyWith(
          category: categories.firstWhereOrNull(
            (element) => element.code == transactions[i].categoryCode,
          ),
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            categories: categories,
            error: error,
            isLoading: false,
            transactions: transactions,
          ),
        );
      }
    }
  }

  Future<void> _onAddTransactionEvent(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    String error = '';
    Transaction? transaction;
    final List<Transaction> transactions = [...state.transactions];
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: error,
        ),
      );
      final Either<Failure, Transaction> eitherTransaction =
          await transactionService.save(event.transaction);
      eitherTransaction.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          if (data.date.compareTo(state.startDate) >= 0 &&
              data.date.compareTo(state.endDate) <= 0) {
            transaction = data;
          }
        },
      );
      if (error.isNotEmpty || transaction == null) return;
      transactions.add(transaction!);
      transactions.sort(
        (a, b) => b.date.compareTo(a.date),
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            error: error,
            isLoading: false,
            transactions: transactions,
          ),
        );
      }
    }
  }
}
