import 'package:flutter/material.dart';
import 'package:track_my_money/ui/pages/dashboard/widgets/dashboard_current_balance.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DashboardCurrentBalance(),
          ),
        ],
      ),
    );
  }
}
