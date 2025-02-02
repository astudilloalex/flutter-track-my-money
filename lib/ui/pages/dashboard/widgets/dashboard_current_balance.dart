import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCurrentBalance extends StatelessWidget {
  const DashboardCurrentBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.currentBalance),
      ),
    );
  }
}
