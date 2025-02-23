import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
