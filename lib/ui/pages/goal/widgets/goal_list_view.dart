import 'package:flutter/material.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/ui/pages/goal/widgets/goal_card.dart';

class GoalListView extends StatelessWidget {
  const GoalListView({
    super.key,
    required this.goals,
  });

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return GoalCard(goal: goals[index]);
      },
      itemCount: goals.length,
    );
  }
}
