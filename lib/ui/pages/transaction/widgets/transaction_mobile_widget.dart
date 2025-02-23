import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';
import 'package:track_my_money/ui/pages/transaction/widgets/transaction_mobile_card.dart';

class TransactionMobileWidget extends StatelessWidget {
  const TransactionMobileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, List<Transaction>>(
      selector: (state) => state.transactions,
      builder: (context, transactions) {
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 15.0),
          itemBuilder: (context, index) {
            return TransactionMobileCard(transaction: transactions[index]);
          },
          itemCount: transactions.length,
        );
      },
    );
  }
}
