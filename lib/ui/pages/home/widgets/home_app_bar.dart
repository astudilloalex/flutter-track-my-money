import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_bloc.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_event.dart';
import 'package:track_my_money/ui/pages/home/bloc/home_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.currentTab == 3 || state.currentTab == 4) {
          return const SizedBox.shrink();
        }
        return AppBar(
          titleTextStyle: const TextStyle(
            fontSize: 16.0,
          ),
          title: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: () {
              showDateRangePicker(
                context: context,
                firstDate: state.startDate.add(const Duration(days: -365)),
                lastDate: DateTime.now().add(const Duration(days: 180)),
                initialDateRange: DateTimeRange(
                  start: state.startDate,
                  end: state.endDate,
                ),
              ).then(
                (value) {
                  if (value == null || !context.mounted) return;
                  context.read<HomeBloc>().add(
                        ChangeDateRangeHomeEvent(
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
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
