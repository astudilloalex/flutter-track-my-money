import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:track_my_money/ui/pages/dashboard/bloc/dashboard_state.dart';
import 'package:track_my_money/ui/pages/dashboard/models/transaction_trend_model.dart';
import 'package:track_my_money/ui/utils/code_mapper.dart';
import 'package:track_my_money/ui/widgets/indicator.dart';

class DashboardComparison extends StatelessWidget {
  const DashboardComparison({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.comparison,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.23,
                    child: BlocSelector<DashboardBloc, DashboardState,
                        List<TransactionTrendModel>>(
                      selector: (state) => state.transactionSummaryTypes,
                      builder: (context, transactionSummaryTypes) {
                        final Decimal total = transactionSummaryTypes.fold(
                          Decimal.zero,
                          (previousValue, element) =>
                              previousValue +
                              Decimal.parse(
                                element.amount.toString(),
                              ),
                        );
                        return PieChart(
                          PieChartData(
                            sections: [
                              ...transactionSummaryTypes.map(
                                (e) => PieChartSectionData(
                                  value: e.amount,
                                  title:
                                      '${total.compareTo(Decimal.zero) == 0 ? 0 : ((e.amount * 100) / total.toDouble()).toStringAsFixed(1)}%',
                                  color: Color(e.type.color),
                                  titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    ...TypeEnum.values.map(
                      (e) => Indicator(
                        color: Color(e.color),
                        text: CodeMapper.fromCode(context, e.name),
                        isSquare: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
