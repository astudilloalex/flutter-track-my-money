import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_event.dart';
import 'package:track_my_money/ui/pages/dashboard/widgets/dashboard_comparison.dart';
import 'package:track_my_money/ui/pages/dashboard/widgets/dashboard_transaction_trend.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.transactions != current.transactions,
      listener: (context, state) {
        if (state.transactions.isNotEmpty) {
          context.read<DashboardBloc>().add(
                ChangeTransactionDashboardEvent(
                  transactions: state.transactions,
                ),
              );
        }
      },
      child: const Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DashboardComparison(),
            ),
            SliverToBoxAdapter(
              child: DashboardTransactionTrend(),
            ),
          ],
        ),
      ),
    );
  }
}
