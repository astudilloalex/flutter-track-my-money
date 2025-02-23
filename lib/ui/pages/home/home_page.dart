import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_event.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';
import 'package:track_my_money/ui/pages/home/widgets/home_app_bar.dart';
import 'package:track_my_money/ui/routes/route_name.dart';
import 'package:track_my_money/ui/utils/responsive_util.dart';
import 'package:track_my_money/ui/widgets/add_edit_transaction_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.isLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child:
          ResponsiveUtil.isDesktop(context) || ResponsiveUtil.isTablet(context)
              ? _DesktopLayout(context, child: child)
              : _MobileLayout(context, child: child),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout(this.context, {required this.child});

  final Widget child;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return NavigationRail(
                selectedIndex: state.currentTab,
                onDestinationSelected: (value) {
                  context.read<HomeBloc>().add(TabChangedHomeEvent(value));
                },
                labelType: NavigationRailLabelType.selected,
                trailing: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet<Transaction>(
                      isDismissible: false,
                      context: this.context,
                      builder: (_) {
                        return AddEditTransactionBottomSheet(
                          categories:
                              this.context.read<HomeBloc>().state.categories,
                        );
                      },
                    ).then(
                      (value) {
                        if (value == null || !this.context.mounted) return;
                        this.context.read<HomeBloc>().add(
                              AddTransactionHomeEvent(transaction: value),
                            );
                      },
                    );
                  },
                  child: const Icon(FontAwesomeIcons.plus),
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(FontAwesomeIcons.house),
                    label: Text(AppLocalizations.of(context)!.home),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(FontAwesomeIcons.list),
                    label: Text(AppLocalizations.of(context)!.transactions),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(FontAwesomeIcons.chartPie),
                    label: Text(AppLocalizations.of(context)!.budgets),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(FontAwesomeIcons.solidFlag),
                    label: Text(AppLocalizations.of(context)!.goals),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(FontAwesomeIcons.solidUser),
                    label: Text(AppLocalizations.of(context)!.settings),
                  ),
                ],
              );
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                BlocSelector<HomeBloc, HomeState, int>(
                  selector: (state) => state.currentTab,
                  builder: (context, index) {
                    if (index == 3 || index == 4) {
                      return const SizedBox.shrink();
                    }
                    return const HomeAppBar();
                  },
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout(this.context, {required this.child});

  final Widget child;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<Transaction>(
            isDismissible: false,
            context: this.context,
            builder: (_) {
              return AddEditTransactionBottomSheet(
                categories: this.context.read<HomeBloc>().state.categories,
              );
            },
          ).then(
            (value) {
              if (value == null || !this.context.mounted) return;
              this.context.read<HomeBloc>().add(
                    AddTransactionHomeEvent(transaction: value),
                  );
            },
          );
        },
        icon: const Icon(FontAwesomeIcons.plus),
        label: Text(AppLocalizations.of(context)!.transaction),
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return NavigationBar(
            selectedIndex: state.currentTab,
            onDestinationSelected: (value) {
              context.read<HomeBloc>().add(TabChangedHomeEvent(value));
              switch (value) {
                case 0:
                  context.go(RouteName.home);
                case 1:
                  context.go(RouteName.transaction);
                case 3:
                  context.go(RouteName.goal);
                case 4:
                  context.go(RouteName.setting);
              }
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(FontAwesomeIcons.house),
                label: AppLocalizations.of(context)!.home,
              ),
              NavigationDestination(
                icon: const Icon(FontAwesomeIcons.list),
                label: AppLocalizations.of(context)!.transactions,
              ),
              NavigationDestination(
                icon: const Icon(FontAwesomeIcons.chartPie),
                label: AppLocalizations.of(context)!.budgets,
              ),
              NavigationDestination(
                icon: const Icon(FontAwesomeIcons.solidFlag),
                label: AppLocalizations.of(context)!.goals,
              ),
              NavigationDestination(
                icon: const Icon(FontAwesomeIcons.solidUser),
                label: AppLocalizations.of(context)!.settings,
              ),
            ],
          );
        },
      ),
    );
  }
}
