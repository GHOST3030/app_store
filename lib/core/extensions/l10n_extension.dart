import 'package:flutter/material.dart';
import 'package:new_auth/l10n/app_localizations.dart';


extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
