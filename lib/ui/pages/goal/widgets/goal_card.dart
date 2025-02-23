import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/goal_type_enum.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_bloc.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_event.dart';
import 'package:track_my_money/ui/pages/goal/widgets/add_edit_goal_bottom_sheet.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final double progress =
        (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final int remainingDays = goal.deadline.difference(DateTime.now()).inDays;
    final Locale locale = Localizations.localeOf(context);
    final format = NumberFormat.simpleCurrency(locale: locale.toString());
    final String currencySymbol = format.currencySymbol;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet<Goal?>(
                      context: context,
                      useRootNavigator: true,
                      builder: (context) {
                        return AddEditGoalBottomSheet(goal: goal);
                      },
                    ).then(
                      (value) {
                        if (value == null || !context.mounted) return;
                        context
                            .read<GoalBloc>()
                            .add(UpdateGoalEvent(goal: value));
                      },
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.pen),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: progress,
              borderRadius: BorderRadius.circular(16.0),
            ),
            Text.rich(
              TextSpan(
                text: '${AppLocalizations.of(context)!.progress}: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: ' ${(progress * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: '${AppLocalizations.of(context)!.currentAmount}: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text:
                        '$currencySymbol${goal.currentAmount.toStringAsFixed(2)} / $currencySymbol${goal.targetAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                text: '${AppLocalizations.of(context)!.deadline}: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: DateFormat('dd MMM yyyy').format(goal.deadline),
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 16.0,
              children: [
                if (remainingDays < 0)
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.goalXCompleted(
                        ((goal.currentAmount / goal.targetAmount) * 100)
                            .toStringAsFixed(2),
                      ),
                      style: TextStyle(
                        color: progress < 1.0 ? Colors.redAccent : Colors.green,
                      ),
                    ),
                  ),
                if (remainingDays >= 0 && remainingDays <= 30)
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.xDaysLeft(remainingDays),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                if (remainingDays > 30)
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.xDaysLeft(remainingDays),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                if (goal.goalType == GoalTypeEnum.automatic)
                  const Icon(FontAwesomeIcons.a, color: Color(0xFF28A745)),
                if (goal.goalType == GoalTypeEnum.manual)
                  const Icon(FontAwesomeIcons.m, color: Color(0xFFFFC107)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
