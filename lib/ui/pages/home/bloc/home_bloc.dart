import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/app/extension/date_time_extensions.dart';
import 'package:track_my_money/src/category/application/category_service.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/transaction/application/transaction_service.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_event.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.categoryService,
    required this.transactionService,
    int? currentTab,
  }) : super(
          HomeState(
            currentTab: currentTab ?? 0,
            endDate: DateTime.now().lastDayOfMonth.copyWith(
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
    log('HomeBloc created', name: 'Bloc');
    on<AddTransactionHomeEvent>(_onAddTransactionHomeEvent);
    on<ChangeDateRangeHomeEvent>(_onChangeDateRangeHomeEvent);
    on<InitialHomeEvent>(_onInitialHomeEvent);
    on<LoadCategoryHomeEvent>(_onLoadCategoryHomeEvent);
    on<TabChangedHomeEvent>(_onTabChanged);
    add(const InitialHomeEvent());
  }

  final CategoryService categoryService;
  final TransactionService transactionService;

  @override
  Future<void> close() {
    log('HomeBloc closed', name: 'Bloc');
    return super.close();
  }

  Future<void> _onChangeDateRangeHomeEvent(
    ChangeDateRangeHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    String error = '';
    List<Transaction> transactions = [];
    if (isClosed) return;
    try {
      emit(
        state.copyWith(
          endDate: event.endDate.copyWith(
            hour: 23,
            minute: 59,
            second: 59,
            microsecond: 999,
            millisecond: 999,
          ),
          error: error,
          isLoading: true,
          startDate: event.startDate.copyWith(
            hour: 0,
            minute: 0,
            second: 0,
            microsecond: 0,
            millisecond: 0,
          ),
        ),
      );
      final Either<Failure, List<Transaction>> eitherTransaction =
          await _transactions;
      eitherTransaction.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          transactions = data;
        },
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

  Future<void> _onInitialHomeEvent(
    InitialHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    String error = '';
    List<Category> categories = [];
    List<Transaction> transactions = [];
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
      // Get categories
      final Either<Failure, List<Category>> eitherCategory =
          await categoryService.getAll(
        onlyActive: true,
      );
      eitherCategory.fold(
        (failure) {
          error = failure.code;
          log(error);
        },
        (data) {
          categories = data;
        },
      );
      if (error.isNotEmpty) return;
      // Get transactions
      final Either<Failure, List<Transaction>> eitherTransaction =
          await _transactions;
      eitherTransaction.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          transactions = data;
        },
      );
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

  void _onTabChanged(
    TabChangedHomeEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        currentTab: event.tabIndex,
        error: '',
        isLoading: false,
      ),
    );
  }

  Future<void> _onLoadCategoryHomeEvent(
    LoadCategoryHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    String error = '';
    List<Category> categories = [];
    try {
      emit(
        state.copyWith(
          categories: categories,
          error: error,
          isLoading: true,
        ),
      );
      final Either<Failure, List<Category>> eitherCategory =
          await categoryService.getAll(
        onlyActive: true,
      );
      eitherCategory.fold(
        (failure) {
          error = failure.code;
        },
        (data) {
          categories = data;
        },
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (!isClosed) {
        emit(
          state.copyWith(
            categories: categories,
            error: error,
            isLoading: false,
          ),
        );
      }
    }
  }

  Future<void> _onAddTransactionHomeEvent(
    AddTransactionHomeEvent event,
    Emitter<HomeState> emit,
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
            transaction = data.copyWith(
              category: state.categories.firstWhereOrNull(
                (element) => element.code == data.categoryCode,
              ),
            );
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

  Future<Either<Failure, List<Transaction>>> get _transactions async {
    List<Transaction> transactions = [];
    final Either<Failure, List<Transaction>> eitherTransaction =
        await transactionService.findByDateRange(
      startDate: state.startDate,
      endDate: state.endDate,
      categoryCodes: state.categoryCodes,
      typeIds: state.typeIds,
    );
    return eitherTransaction.fold(
      (failure) {
        return Left(failure);
      },
      (data) {
        transactions = data;
        for (int i = 0; i < transactions.length; i++) {
          transactions[i] = transactions[i].copyWith(
            category: state.categories.firstWhereOrNull(
              (element) => element.code == transactions[i].categoryCode,
            ),
          );
        }
        return Right(transactions);
      },
    );
  }
}
