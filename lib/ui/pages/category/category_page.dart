import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:track_my_money/app/extension/date_time_extensions.dart';
import 'package:track_my_money/src/category/domain/category.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_bloc.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_event.dart';
import 'package:track_my_money/ui/pages/category/bloc/category_state.dart';
import 'package:track_my_money/ui/pages/category/widgets/category_card.dart';
import 'package:track_my_money/ui/utils/responsive_util.dart';
import 'package:track_my_money/ui/widgets/add_edit_category_dialog.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state.isLoading) {
              context.loaderOverlay.show();
              return;
            }
            if (!state.isLoading) {
              context.loaderOverlay.hide();
            }
          },
          child: Text(AppLocalizations.of(context)!.categories),
        ),
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < ResponsiveUtil.tabletChangePoint) {
            return FloatingActionButton(
              onPressed: () {
                showDialog<Category?>(
                  context: context,
                  builder: (context) => const AddEditCategoryDialog(),
                ).then(
                  (value) {
                    if (value == null || !context.mounted) return;
                    context
                        .read<CategoryBloc>()
                        .add(AddCategoryEvent(category: value));
                  },
                );
              },
              tooltip: AppLocalizations.of(context)!.addCategory,
              child: const Icon(FontAwesomeIcons.plus),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: ResponsiveUtil.isDesktop(context)
          ? const _DesktopLayout()
          : ResponsiveUtil.isTablet(context)
              ? const _TabletLayout()
              : const _MobileLayout(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final Category category = state.categories[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                leading: Icon(
                  category.type == TypeEnum.income
                      ? FontAwesomeIcons.arrowTrendUp
                      : FontAwesomeIcons.arrowTrendDown,
                  color: category.type == TypeEnum.income
                      ? Colors.green
                      : Colors.red,
                ),
                title: Text(category.name),
                subtitle: Text(
                  '${AppLocalizations.of(context)!.created}: ${category.createdAt.toLocal().toShortDateString()}',
                ),
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
                trailing: Switch.adaptive(
                  value: category.active,
                  onChanged: (value) {
                    context.read<CategoryBloc>().add(
                          UpdateCategoryEvent(
                            category: category.copyWith(active: value),
                          ),
                        );
                  },
                ),
              ),
            );
          },
          itemCount: state.categories.length,
        );
      },
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 2.0,
          ),
          itemBuilder: (context, index) {
            final Category category = state.categories[index];
            return CategoryCard(category: category);
          },
          itemCount: state.categories.length,
        );
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2.0,
          ),
          itemBuilder: (context, index) {
            final Category category = state.categories[index];
            return CategoryCard(category: category);
          },
          itemCount: state.categories.length,
        );
      },
    );
  }
}
