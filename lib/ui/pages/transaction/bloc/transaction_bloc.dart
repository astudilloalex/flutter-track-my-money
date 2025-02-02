import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_event.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionState()) {
    log('TransactionBloc created', name: 'Bloc');
  }

  @override
  Future<void> close() {
    log('TransactionBloc closed', name: 'Bloc');
    return super.close();
  }
}
