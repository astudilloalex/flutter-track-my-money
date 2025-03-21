import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';

final class TransactionState extends Equatable {
  const TransactionState({
    this.categories = const <Category>[],
    this.categoryCodes = const <String>[],
    required this.endDate,
    this.error = '',
    this.isLoading = false,
    required this.startDate,
    this.transactions = const <Transaction>[],
    this.typeIds = const <int>[],
  });

  final List<Category> categories;
  final List<String> categoryCodes;
  final DateTime endDate;
  final String error;
  final bool isLoading;
  final DateTime startDate;
  final List<Transaction> transactions;
  final List<int> typeIds;

  @override
  List<Object?> get props {
    return [
      categories,
      categoryCodes,
      endDate,
      error,
      isLoading,
      startDate,
      transactions,
      typeIds,
    ];
  }

  TransactionState copyWith({
    List<Category>? categories,
    List<String>? categoryCodes,
    DateTime? endDate,
    String? error,
    bool? isLoading,
    DateTime? startDate,
    List<Transaction>? transactions,
    List<int>? typeIds,
  }) {
    return TransactionState(
      categories: categories ?? this.categories,
      categoryCodes: categoryCodes ?? this.categoryCodes,
      endDate: endDate ?? this.endDate,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      startDate: startDate ?? this.startDate,
      transactions: transactions ?? this.transactions,
      typeIds: typeIds ?? this.typeIds,
    );
  }
}
