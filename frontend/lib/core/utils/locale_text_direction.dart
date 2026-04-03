//? Helpers for localized text direction while app layout stays LTR.
//? Arabic UI strings use RTL reading order; EN/FR use LTR.

import 'package:flutter/material.dart';

//& isArabic
//* Returns true if the current locale is Arabic.
bool isArabic(BuildContext context) {
  return Localizations.localeOf(context).languageCode == 'ar';
}

//& textDirectionForUiLocale
//* Returns RTL for Arabic locale strings; LTR otherwise.
TextDirection textDirectionForUiLocale(BuildContext context) {
  return isArabic(context) ? TextDirection.rtl : TextDirection.ltr;
}
