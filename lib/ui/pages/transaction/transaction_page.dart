import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_bloc.dart';
import 'package:track_my_money/ui/pages/transaction/bloc/transaction_state.dart';
import 'package:track_my_money/ui/pages/transaction/widgets/transaction_app_bar.dart';
import 'package:track_my_money/ui/pages/transaction/widgets/transaction_mobile_widget.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransactionAppBar(),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {},
        child: const TransactionMobileWidget(),
      ),
    );
  }
}
