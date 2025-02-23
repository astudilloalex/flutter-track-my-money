import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_state.dart';
import 'package:track_my_money/ui/pages/dashboard/models/transaction_trend_model.dart';

class DashboardTransactionTrend extends StatelessWidget {
  const DashboardTransactionTrend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E1F5A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.transactionTrend,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16.0),
            AspectRatio(
              aspectRatio: 1.23,
              child: BlocSelector<DashboardBloc, DashboardState,
                  List<TransactionTrendModel>>(
                selector: (state) => state.transactionTrends,
                builder: (context, transactionTrends) {
                  return LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                NumberFormat.compact().format(value),
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        bottomTitles: const AxisTitles(),
                      ),
                      gridData: const FlGridData(show: false),
                      lineBarsData: [
                        ...TypeEnum.values.map(
                          (type) {
                            return LineChartBarData(
                              //isCurved: true,
                              color: Color(type.color),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(type.color).withValues(
                                  alpha: 0.25,
                                ),
                              ),
                              spots: [
                                ...transactionTrends
                                    .where((element) => element.type == type)
                                    .map(
                                      (transactionTrend) => FlSpot(
                                        transactionTrend
                                            .date.millisecondsSinceEpoch
                                            .toDouble(),
                                        transactionTrend.amount,
                                      ),
                                    ),
                              ],
                              dotData: FlDotData(
                                checkToShowDot: (spot, barData) {
                                  final List<FlSpot> spots = barData.spots;
                                  final int index = spots.indexOf(spot);
                                  if (index == 0 || index == spots.length - 1) {
                                    return true;
                                  }
                                  final FlSpot prev = spots[index - 1];
                                  final FlSpot next = spots[index + 1];

                                  final bool isLocalMax =
                                      spot.y > prev.y && spot.y > next.y;
                                  final bool isLocalMin =
                                      spot.y < prev.y && spot.y < next.y;

                                  return isLocalMax || isLocalMin;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            BlocSelector<DashboardBloc, DashboardState,
                List<TransactionTrendModel>>(
              selector: (state) => state.transactionTrends,
              builder: (context, transactionTrends) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...transactionTrends
                        .groupListsBy((element) => element.date.month)
                        .keys
                        .map(
                          (e) => Text(
                            DateFormat('MMM')
                                .format(DateTime.now().copyWith(month: e)),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
