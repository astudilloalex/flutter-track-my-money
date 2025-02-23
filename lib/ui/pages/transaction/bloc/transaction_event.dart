import 'package:equatable/equatable.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props {
    return [];
  }
}

final class InitialTransactionEvent extends TransactionEvent {
  const InitialTransactionEvent();
}

final class AddTransactionEvent extends TransactionEvent {
  const AddTransactionEvent({
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
