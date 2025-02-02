import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_event.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';
import 'package:track_my_money/ui/utils/responsive_screen_setting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= ResponsiveScreenSetting.tabletChangePoint) {
          return _MobileLayout(child: child);
        } else {
          return _DesktopLayout(child: child);
        }
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.child});

  final Widget child;

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
                ],
              );
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return NavigationBar(
            selectedIndex: state.currentTab,
            onDestinationSelected: (value) {
              context.read<HomeBloc>().add(TabChangedHomeEvent(value));
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
            ],
          );
        },
      ),
    );
  }
}
