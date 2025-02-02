import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:track_my_money/ui/pages/sign_in/bloc/sign_in_event.dart';

class SignInGoogleButton extends StatelessWidget {
  const SignInGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(FontAwesomeIcons.google),
      label: Text(AppLocalizations.of(context)!.continueWithGoogle),
      onPressed: () {
        context.read<SignInBloc>().add(const GoogleSignInEvent());
      },
    );
  }
}
