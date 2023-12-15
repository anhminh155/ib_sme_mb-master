import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

setLocale(Locale locale) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('current_languageCode', locale.languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? currentLocale = prefs.getString('current_languageCode');
  if (currentLocale != null) {
    return Locale(currentLocale);
  } else {
    return const Locale('vi');
  }
}

AppLocalizations? translation(BuildContext context) {
  return AppLocalizations.of(context);
}
