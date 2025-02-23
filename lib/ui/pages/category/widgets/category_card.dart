import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track_my_money/app/extension/date_time_extensions.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_bloc.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_event.dart';
import 'package:track_my_money/ui/utils/code_mapper.dart';
import 'package:track_my_money/ui/widgets/add_edit_category_dialog.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onLongPress: () {
          showDialog<Category?>(
            context: context,
            builder: (context) => AddEditCategoryDialog(
              category: category,
            ),
          ).then(
            (value) {
              if (value == null || !context.mounted) return;
              context
                  .read<CategoryBloc>()
                  .add(UpdateCategoryEvent(category: value));
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: Row(
            spacing: 16.0,
            children: [
              Icon(
                category.type == TypeEnum.income
                    ? FontAwesomeIcons.arrowTrendUp
                    : FontAwesomeIcons.arrowTrendDown,
                color: category.type == TypeEnum.income
                    ? Colors.green
                    : Colors.red,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      CodeMapper.fromCode(context, category.type.name),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.created}: ${category.createdAt.toLocal().toShortDateString()}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: category.active,
                onChanged: (value) {
                  context.read<CategoryBloc>().add(
                        UpdateCategoryEvent(
                          category: category.copyWith(active: value),
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
