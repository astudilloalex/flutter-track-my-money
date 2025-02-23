import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/utils/code_mapper.dart';

class AddEditTransactionBottomSheet extends StatefulWidget {
  const AddEditTransactionBottomSheet({
    super.key,
    this.categories = const <Category>[],
    this.transaction,
  });

  final List<Category> categories;
  final Transaction? transaction;

  @override
  State<AddEditTransactionBottomSheet> createState() =>
      _AddEditTransactionBottomSheetState();
}

class _AddEditTransactionBottomSheetState
    extends State<AddEditTransactionBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategoryCode;
  TypeEnum? selectedType;
  DateTime date = DateTime.now();
  String error = '';

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  @override
  void dispose() {
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
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
    dateController.text = DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }

  void saveTransaction(BuildContext context) {
    setState(() => error = '');
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (selectedType == null) {
      setState(() => error = AppLocalizations.of(context)!.selectTheType);
      return;
    }
    final Transaction transaction = widget.transaction?.copyWith(
          amount: double.parse(amountController.text.trim()),
          categoryCode: selectedCategoryCode,
          date: date,
          description: descriptionController.text.trim(),
          type: selectedType,
        ) ??
        Transaction(
          amount: double.parse(amountController.text.trim()),
          categoryCode: selectedCategoryCode!,
          createdAt: DateTime.now(),
          date: date,
          description: descriptionController.text.trim(),
          type: selectedType!,
          updatedAt: DateTime.now(),
          userCode: '',
        );
    context.pop(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag handle at the top of the bottom sheet
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 16.0),
        // Header with title and close button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.transaction == null
                    ? AppLocalizations.of(context)!.addTransaction
                    : AppLocalizations.of(context)!.editTransaction,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(FontAwesomeIcons.circleXmark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),

        // Form with transaction details
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                // Row of ChoiceChips for selecting transaction type
                Wrap(
                  spacing: 16.0,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ...TypeEnum.values.map(
                      (type) => ChoiceChip(
                        label: Text(
                          CodeMapper.fromCode(
                            context,
                            type.name,
                          ),
                        ),
                        onSelected: (value) {
                          setState(
                            () => selectedType = value ? type : null,
                          );
                        },
                        selected: selectedType == type,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Amount text field
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.amount,
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
                // Description text field
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                    prefixIcon: const Icon(FontAwesomeIcons.list),
                  ),
                  minLines: 2,
                  maxLines: 2,
                  maxLength: 255,
                ),
                const SizedBox(height: 16.0),
                // Dropdown for categories
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.category,
                    prefixIcon: const Icon(FontAwesomeIcons.layerGroup),
                  ),
                  value: selectedCategoryCode,
                  items: [
                    ...widget.categories.map(
                      (category) => DropdownMenuItem(
                        value: category.code,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategoryCode = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.selectCategory;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Date/time field
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.date,
                    prefixIcon: const Icon(FontAwesomeIcons.solidCalendar),
                  ),
                  onTap: () {
                    changeDate(context);
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
                onPressed: () => saveTransaction(context),
                label: Text(
                  widget.transaction == null
                      ? AppLocalizations.of(context)!.save
                      : AppLocalizations.of(context)!.update,
                ),
                icon: Icon(
                  widget.transaction == null
                      ? FontAwesomeIcons.floppyDisk
                      : FontAwesomeIcons.rotate,
                ),
              ),
            ],
          ),
        ),
        if (error.isNotEmpty) const SizedBox(height: 16.0),
        if (error.isNotEmpty)
          Text(
            error,
            style: const TextStyle(
              color: Colors.redAccent,
            ),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
