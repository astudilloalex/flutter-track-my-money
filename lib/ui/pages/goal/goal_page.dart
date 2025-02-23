import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_bloc.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_event.dart';
import 'package:track_my_money/ui/pages/goal/bloc/goal_state.dart';
import 'package:track_my_money/ui/pages/goal/widgets/add_edit_goal_bottom_sheet.dart';
import 'package:track_my_money/ui/pages/goal/widgets/goal_list_view.dart';

class GoalPage extends StatelessWidget {
  const GoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              showModalBottomSheet<Goal?>(
                context: context,
                useRootNavigator: true,
                builder: (context) {
                  return const AddEditGoalBottomSheet();
                },
              ).then(
                (value) {
                  if (value == null || !context.mounted) return;
                  context.read<GoalBloc>().add(AddGoalEvent(goal: value));
                },
              );
            },
            icon: const Icon(FontAwesomeIcons.plus),
            label: Text(AppLocalizations.of(context)!.addGoal),
          ),
        ],
        title: BlocListener<GoalBloc, GoalState>(
          listener: (context, state) {
            if (state.error.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.goals),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: BlocBuilder<GoalBloc, GoalState>(
              builder: (context, state) {
                return InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () {
                    showDateRangePicker(
                      context: context,
                      firstDate:
                          state.startDate.add(const Duration(days: -365)),
                      lastDate: DateTime.now().add(const Duration(days: 180)),
                      initialDateRange: DateTimeRange(
                        start: state.startDate,
                        end: state.endDate,
                      ),
                    ).then(
                      (value) {
                        if (value == null || !context.mounted) return;
                        context.read<GoalBloc>().add(
                              ChangeDateRangeGoalEvent(
                                endDate: value.end,
                                startDate: value.start,
                              ),
                            );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.0,
                    children: [
                      SizedBox(
                        width: 120.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              DateFormat('d MMM, yyyy').format(state.startDate),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.remove_outlined),
                      SizedBox(
                        width: 120.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              DateFormat('d MMM, yyyy').format(state.endDate),
                              textAlign: TextAlign.center,
                            ),
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
      ),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state.goals.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.thereAreNoGoalsToShow),
            );
          }
          return Column(
            children: [
              if (state.isLoading) const LinearProgressIndicator(),
              Expanded(child: GoalListView(goals: state.goals)),
            ],
          );
        },
      ),
    );
  }
}
