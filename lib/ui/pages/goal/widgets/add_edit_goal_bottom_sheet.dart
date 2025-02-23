import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/src/goal/domain/goal.dart';
import 'package:track_my_money/src/goal/domain/goal_type_enum.dart';
import 'package:track_my_money/ui/utils/code_mapper.dart';

class AddEditGoalBottomSheet extends StatefulWidget {
  const AddEditGoalBottomSheet({
    super.key,
    this.goal,
  });

  final Goal? goal;

  @override
  State<AddEditGoalBottomSheet> createState() => _AddEditGoalBottomSheetState();
}

class _AddEditGoalBottomSheetState extends State<AddEditGoalBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentAmountController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  GoalTypeEnum selectedGoalType = GoalTypeEnum.automatic;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.goal?.name ?? '';
    currentAmountController.text = widget.goal?.currentAmount.toStringAsFixed(
          2,
        ) ??
        '0.00';
    targetAmountController.text = widget.goal?.targetAmount.toStringAsFixed(
          2,
        ) ??
        '';
    deadlineController.text = DateFormat('d MMM, yyyy').format(
      widget.goal?.deadline ?? DateTime.now().add(const Duration(days: 30)),
    );
    selectedGoalType = widget.goal?.goalType ?? GoalTypeEnum.automatic;
    date = widget.goal?.deadline ?? date.add(const Duration(days: 30));
  }

  @override
  void dispose() {
    nameController.dispose();
    currentAmountController.dispose();
    targetAmountController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void saveGoal(BuildContext context) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final Goal goal = widget.goal?.copyWith(
          currentAmount: double.parse(currentAmountController.text.trim()),
          goalType: selectedGoalType,
          name: nameController.text.trim(),
          targetAmount: double.parse(targetAmountController.text),
        ) ??
        Goal(
          createdAt: DateTime.now(),
          currentAmount: double.parse(currentAmountController.text),
          deadline: DateFormat('d MMM, yyyy').parse(deadlineController.text),
          goalType: selectedGoalType,
          name: nameController.text.trim(),
          targetAmount: double.parse(targetAmountController.text),
          updatedAt: DateTime.now(),
          userCode: '',
        );
    context.pop(goal);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.goal == null
                    ? AppLocalizations.of(context)!.addGoal
                    : AppLocalizations.of(context)!.editGoal,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(FontAwesomeIcons.circleXmark),
              ),
            ],
          ),
        ),
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Wrap(
                  spacing: 16.0,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ...GoalTypeEnum.values.map(
                      (type) => ChoiceChip(
                        label: Text(
                          CodeMapper.fromCode(
                            context,
                            type.name,
                          ),
                        ),
                        onSelected: (value) {
                          setState(
                            () => selectedGoalType =
                                value ? type : selectedGoalType,
                          );
                        },
                        selected: selectedGoalType == type,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                    prefixIcon: const Icon(FontAwesomeIcons.list),
                  ),
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 150,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return AppLocalizations.of(context)!.invalidName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  controller: deadlineController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.deadline,
                    prefixIcon: const Icon(FontAwesomeIcons.solidCalendar),
                  ),
                  onTap: () {
                    changeDate(context);
                  },
                ),
                const SizedBox(height: 16.0),
                // Amount text field
                TextFormField(
                  controller: targetAmountController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.targetAmount,
                    prefixIcon: const Icon(FontAwesomeIcons.dollarSign),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!.invalidAmount;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: currentAmountController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.currentAmount,
                    prefixIcon: const Icon(FontAwesomeIcons.dollarSign),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!.invalidAmount;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 16.0,
            children: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                label: Text(
                  AppLocalizations.of(context)!.cancel,
                ),
                icon: const Icon(FontAwesomeIcons.ban),
              ),
              ElevatedButton.icon(
                onPressed: () => saveGoal(context),
                label: Text(
                  widget.goal == null
                      ? AppLocalizations.of(context)!.save
                      : AppLocalizations.of(context)!.update,
                ),
                icon: Icon(
                  widget.goal == null
                      ? FontAwesomeIcons.floppyDisk
                      : FontAwesomeIcons.rotate,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  /// Opens a date picker and time picker for the user to select a date/time.
  ///
  /// If the user confirms both picks, updates [date] and [dateController]
  /// with the chosen values. This is triggered when the date field is tapped.
  ///
  /// [context] is the BuildContext from which the date/time pickers are shown.
  Future<void> changeDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    // Open the date picker, constrained between (today - 365 days) and (today + 30 days).
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: today.add(const Duration(days: -365)),
      lastDate: today.add(const Duration(days: 30)),
      initialDate: date,
      barrierDismissible: false,
    );
    // If the user cancels or the context is no longer valid, do nothing.
    if (selectedDate == null || !context.mounted) return;
    // Open the time picker for the selected date.
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
      barrierDismissible: false,
    );
    // If the user cancels, do nothing.
    if (selectedTime == null) return;
    // Update the date and the date controller with the newly picked date/time.
    date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    deadlineController.text = DateFormat('d MMM, yyyy').format(date);
  }
}
