import 'package:track_my_money/src/currency/domain/currency_enum.dart';
import 'package:track_my_money/src/language/domain/language_enum.dart';
import 'package:track_my_money/src/user/domain/user.dart';

class UserSetting {
  const UserSetting({
    this.code = '',
    required this.createdAt,
    this.currency = CurrencyEnum.usd,
    this.id = 0,
    this.language = LanguageEnum.en,
    this.notificationEnabled = true,
    required this.updatedAt,
    this.user,
    required this.userCode,
  });

  final String code;
  final DateTime createdAt;
  final CurrencyEnum currency;
  final int id;
  final LanguageEnum language;
  final bool notificationEnabled;
  final DateTime updatedAt;
  final User? user;
  final String userCode;

  UserSetting copyWith({
    String? code,
    DateTime? createdAt,
    CurrencyEnum? currency,
    int? id,
    LanguageEnum? language,
    bool? notificationEnabled,
    DateTime? updatedAt,
    User? user,
    String? userCode,
  }) {
    return UserSetting(
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      currency: currency ?? this.currency,
      id: id ?? this.id,
      language: language ?? this.language,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userCode: userCode ?? this.userCode,
    );
  }
}
