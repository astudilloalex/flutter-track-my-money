import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:track_my_money/src/transaction/domain/transaction.dart';
import 'package:track_my_money/src/type/domain/type_enum.dart';

class TransactionMobileCard extends StatelessWidget {
  const TransactionMobileCard({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.type == TypeEnum.income;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.description == null || transaction.description!.isEmpty
              ? AppLocalizations.of(context)!.noDescription
              : transaction.description!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${transaction.category?.name ?? ''} • ${GetTimeAgo.parse(transaction.date, locale: AppLocalizations.of(context)!.localeName)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
