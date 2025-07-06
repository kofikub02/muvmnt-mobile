import 'package:mvmnt_cli/core/constants/constants.dart';

dynamic getCurrency(String countryCode) {
  return countryCurrencyMap[countryCode];
}
