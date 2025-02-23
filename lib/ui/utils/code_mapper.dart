import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CodeMapper {
  const CodeMapper._();

  static String fromCode(BuildContext context, String code) {
    final Map<String, String> data = {
      'expense': AppLocalizations.of(context)!.expense,
      'income': AppLocalizations.of(context)!.income,
    };
    return data[code] ?? code;
  }
}
