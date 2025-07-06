import 'package:mvmnt_cli/features/location/domain/entities/currency_entity.dart';

const List<Map<String, String>> countryCodes = [
  {
    "label": "+1 🇨🇦 Canada",
    "value": "+1-CA",
    "code": "+1",
    "display": "+1 🇨🇦",
  },
  {
    "label": "+1 🇺🇸 United States",
    "value": "+1-US",
    "code": "+1",
    "display": "+1 🇺🇸",
  },
  {
    "label": "+233 🇬🇭 Ghana",
    "value": "+233-GH",
    "code": "+233",
    "display": "+233 🇬🇭",
  },
  {
    "label": "+234 🇳🇬 Nigeria",
    "value": "+234-NG",
    "code": "+234",
    "display": "+234 🇳🇬",
  },
  {
    "label": "+27 🇿🇦 South Africa",
    "value": "+27-ZA",
    "code": "+27",
    "display": "+27 🇿🇦",
  },
];

const List<Map<String, String>> mobileMoneyNetworks = [
  {
    "label": "MTN Mobile Money",
    "value": "mtn",
    "code": "mtn",
    "display": "MTN Mobile Money",
  },
  {
    "label": "Vodafone Cash",
    "value": "vodafone",
    "code": "vod",
    "display": "Vodafone Cash",
  },
  {
    "label": "AirtelTigo Money",
    "value": "airteltigo",
    "code": "atl",
    "display": "AirtelTigo Money",
  },
  {"label": "M-Pesa", "value": "mpesa", "code": "mpesa", "display": "M-Pesa"},
];

final Map<String, CurrencyEntity> countryCurrencyMap = {
  'NG': CurrencyEntity.fromJson({'code': 'NGN', 'symbol': '₦'}),
  'US': CurrencyEntity.fromJson({'code': 'USD', 'symbol': '\$'}),
  'GH': CurrencyEntity.fromJson({'code': 'GHS', 'symbol': '₵'}),
  'GB': CurrencyEntity.fromJson({'code': 'GBP', 'symbol': '£'}),
  'CA': CurrencyEntity.fromJson({'code': 'CAD', 'symbol': '\$'}),
  // Add more countries as needed
};
