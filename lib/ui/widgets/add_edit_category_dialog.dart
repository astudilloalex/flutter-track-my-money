import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/utils/code_mapper.dart';

class AddEditCategoryDialog extends StatefulWidget {
  const AddEditCategoryDialog({
    super.key,
    this.category,
  });

  final Category? category;

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  TypeEnum? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.category?.type;
    nameController.text = widget.category?.name ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null
            ? AppLocalizations.of(context)!.addCategory
            : AppLocalizations.of(context)!.editCategory,
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
              ),
              validator: (value) {
                if (value != null && value.trim().length >= 2) {
                  return null;
                }
                return AppLocalizations.of(context)!.checkTheName;
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              value: selectedType,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.type,
              ),
              items: [
                ...TypeEnum.values.map(
                  (type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        CodeMapper.fromCode(context, type.name),
                      ),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                selectedType = value;
              },
              validator: (value) {
                if (value != null) return null;
                return AppLocalizations.of(context)!.selectTheType;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(FontAwesomeIcons.xmark),
          label: Text(AppLocalizations.of(context)!.close),
        ),
        TextButton.icon(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            final Category category = widget.category?.copyWith(
                  name: nameController.text.trim(),
                  type: selectedType,
                ) ??
                Category(
                  createdAt: DateTime.now(),
                  name: nameController.text.trim(),
                  type: selectedType!,
                  updatedAt: DateTime.now(),
                  userCode: '',
                );
            Navigator.of(context).pop(category);
          },
          icon: Icon(
            widget.category == null
                ? FontAwesomeIcons.floppyDisk
                : FontAwesomeIcons.rotate,
          ),
          label: Text(
            widget.category == null
                ? AppLocalizations.of(context)!.save
                : AppLocalizations.of(context)!.update,
          ),
        ),
      ],
    );
  }
}
