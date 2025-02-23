import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:track_my_money/ui/pages/setting/widgets/setting_section.dart';
import 'package:track_my_money/ui/pages/setting/widgets/setting_tile.dart';
import 'package:track_my_money/ui/routes/route_name.dart';
import 'package:track_my_money/ui/utils/responsive_util.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ResponsiveUtil.isDesktop(context)
          ? const _DesktopLayout()
          : const _MobileLayout(),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        SettingSection(
          title: AppLocalizations.of(context)!.preferences,
          children: [
            SettingTile(
              icon: FontAwesomeIcons.layerGroup,
              title: AppLocalizations.of(context)!.categories,
              onTap: () {
                context.go(RouteName.category);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
