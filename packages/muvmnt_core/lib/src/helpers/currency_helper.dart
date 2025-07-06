import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyHelper {
  static const String _defaultCurrency = 'USD';
  static const String _defaultLocale = 'en_US';

  // Common currency symbols
  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'CHF': 'Fr',
    'CNY': '¥',
    'SEK': 'kr',
    'NZD': 'NZ\$',
    'MXN': '\$',
    'SGD': 'S\$',
    'HKD': 'HK\$',
    'NOK': 'kr',
    'INR': '₹',
    'BRL': 'R\$',
    'RUB': '₽',
    'KRW': '₩',
    'TRY': '₺',
    'ZAR': 'R',
    'PLN': 'zł',
    'THB': '฿',
    'TWD': 'NT\$',
    'DKK': 'kr',
    'PHP': '₱',
    'IDR': 'Rp',
    'CZK': 'Kč',
    'ILS': '₪',
    'CLP': '\$',
    'PEN': 'S/',
    'COP': '\$',
    'ARS': '\$',
    'UAH': '₴',
    'EGP': 'E£',
    'SAR': 'SR',
    'AED': 'د.إ',
    'QAR': 'QR',
    'KWD': 'KD',
    'BHD': 'BD',
    'OMR': 'OMR',
    'JOD': 'JD',
    'LBP': 'L£',
    'NGN': '₦',
    'GHS': 'GH₵',
    'KES': 'KSh',
    'UGX': 'USh',
    'TZS': 'TSh',
    'ZWL': 'Z\$',
    'MWK': 'MK',
    'ZMW': 'ZK',
    'BWP': 'P',
    'SZL': 'L',
    'LSL': 'L',
    'NAD': 'N\$',
    'MUR': '₨',
    'SCR': '₨',
    'MVR': 'Rf',
    'LKR': '₨',
    'BDT': '৳',
    'NPR': '₨',
    'AFN': '؋',
    'PKR': '₨',
    'IRR': '﷼',
    'IQD': 'ع.د',
    'SYP': '£',
    'LYD': 'LD',
    'TND': 'DT',
    'DZD': 'DA',
    'MAD': 'MAD',
    'ETB': 'Br',
    'ERN': 'Nfk',
    'DJF': 'Fdj',
    'SOS': 'Sh',
    'RWF': 'FRw',
    'BIF': 'FBu',
    'KMF': 'CF',
    'MGA': 'Ar',
    'MZN': 'MT',
    'AO': 'Kz',
    'CDF': 'FC',
    'XAF': 'FCFA',
    'XOF': 'CFA',
    'XPF': 'CFP',
  };

  // Currency decimal places
  static const Map<String, int> _currencyDecimals = {
    'USD': 2,
    'EUR': 2,
    'GBP': 2,
    'JPY': 0,
    'CAD': 2,
    'AUD': 2,
    'CHF': 2,
    'CNY': 2,
    'SEK': 2,
    'NZD': 2,
    'MXN': 2,
    'SGD': 2,
    'HKD': 2,
    'NOK': 2,
    'INR': 2,
    'BRL': 2,
    'RUB': 2,
    'KRW': 0,
    'TRY': 2,
    'ZAR': 2,
    'PLN': 2,
    'THB': 2,
    'TWD': 2,
    'DKK': 2,
    'PHP': 2,
    'IDR': 2,
    'CZK': 2,
    'ILS': 2,
    'CLP': 0,
    'PEN': 2,
    'COP': 2,
    'ARS': 2,
    'UAH': 2,
    'EGP': 2,
    'SAR': 2,
    'AED': 2,
    'QAR': 2,
    'KWD': 3,
    'BHD': 3,
    'OMR': 3,
    'JOD': 3,
    'LBP': 2,
    'NGN': 2,
    'GHS': 2,
    'KES': 2,
    'UGX': 0,
    'TZS': 2,
    'ZWL': 2,
    'MWK': 2,
    'ZMW': 2,
    'BWP': 2,
    'SZL': 2,
    'LSL': 2,
    'NAD': 2,
    'MUR': 2,
    'SCR': 2,
    'MVR': 2,
    'LKR': 2,
    'BDT': 2,
    'NPR': 2,
    'AFN': 2,
    'PKR': 2,
    'IRR': 2,
    'IQD': 3,
    'SYP': 2,
    'LYD': 3,
    'TND': 3,
    'DZD': 2,
    'MAD': 2,
    'ETB': 2,
    'ERN': 2,
    'DJF': 0,
    'SOS': 2,
    'RWF': 0,
    'BIF': 0,
    'KMF': 0,
    'MGA': 2,
    'MZN': 2,
    'AO': 2,
    'CDF': 2,
    'XAF': 0,
    'XOF': 0,
    'XPF': 0,
  };

  /// Format amount with currency
  static String formatCurrency(
    double amount, {
    String? currency,
    String? locale,
    bool showSymbol = true,
    bool showCode = false,
    int? decimalPlaces,
  }) {
    final currencyCode = currency ?? _defaultCurrency;
    final localeCode = locale ?? _defaultLocale;
    final decimals = decimalPlaces ?? getDecimalPlaces(currencyCode);

    try {
      final formatter = NumberFormat.currency(
        locale: localeCode,
        symbol: showSymbol ? getCurrencySymbol(currencyCode) : '',
        name: showCode ? currencyCode : null,
        decimalDigits: decimals,
      );

      return formatter.format(amount);
    } catch (e) {
      // Fallback formatting
      return '${showSymbol ? getCurrencySymbol(currencyCode) : ''}${amount.toStringAsFixed(decimals)}${showCode ? ' $currencyCode' : ''}';
    }
  }

  /// Format amount with compact notation (e.g., 1.2K, 1.5M)
  static String formatCompactCurrency(
    double amount, {
    String? currency,
    String? locale,
    bool showSymbol = true,
  }) {
    final currencyCode = currency ?? _defaultCurrency;
    final localeCode = locale ?? _defaultLocale;

    try {
      final formatter = NumberFormat.compactCurrency(
        locale: localeCode,
        symbol: showSymbol ? getCurrencySymbol(currencyCode) : '',
      );

      return formatter.format(amount);
    } catch (e) {
      // Fallback compact formatting
      return '${showSymbol ? getCurrencySymbol(currencyCode) : ''}${_formatCompact(amount)}';
    }
  }

  /// Get currency symbol
  static String getCurrencySymbol(String currencyCode) {
    return _currencySymbols[currencyCode.toUpperCase()] ?? currencyCode;
  }

  /// Get decimal places for currency
  static int getDecimalPlaces(String currencyCode) {
    return _currencyDecimals[currencyCode.toUpperCase()] ?? 2;
  }

  /// Parse currency string to double
  static double? parseCurrency(String currencyString) {
    if (currencyString.isEmpty) return null;

    try {
      // Remove currency symbols and codes
      String cleanString = currencyString
          .replaceAll(RegExp(r'[^\d.,\-+]'), '')
          .replaceAll(',', '');

      return double.tryParse(cleanString);
    } catch (e) {
      return null;
    }
  }

  /// Calculate percentage
  static double calculatePercentage(double amount, double percentage) {
    return (amount * percentage) / 100;
  }

  /// Calculate discount amount
  static double calculateDiscountAmount(
    double originalPrice,
    double discountPercentage,
  ) {
    return calculatePercentage(originalPrice, discountPercentage);
  }

  /// Calculate discounted price
  static double calculateDiscountedPrice(
    double originalPrice,
    double discountPercentage,
  ) {
    return originalPrice -
        calculateDiscountAmount(originalPrice, discountPercentage);
  }

  /// Calculate tax amount
  static double calculateTaxAmount(double amount, double taxRate) {
    return calculatePercentage(amount, taxRate);
  }

  /// Calculate price with tax
  static double calculatePriceWithTax(double price, double taxRate) {
    return price + calculateTaxAmount(price, taxRate);
  }

  /// Calculate tip amount
  static double calculateTip(double amount, double tipPercentage) {
    return calculatePercentage(amount, tipPercentage);
  }

  /// Calculate total with tip
  static double calculateTotalWithTip(double amount, double tipPercentage) {
    return amount + calculateTip(amount, tipPercentage);
  }

  /// Convert amount between currencies (requires exchange rate)
  static double convertCurrency(double amount, double exchangeRate) {
    return amount * exchangeRate;
  }

  /// Round to currency precision
  static double roundToCurrencyPrecision(double amount, String currencyCode) {
    final decimals = getDecimalPlaces(currencyCode);
    final multiplier = pow(10, decimals);
    return (amount * multiplier).round() / multiplier;
  }

  /// Split amount evenly
  static List<double> splitAmountEvenly(double totalAmount, int numberOfParts) {
    if (numberOfParts <= 0) return [totalAmount];

    final baseAmount = totalAmount / numberOfParts;
    final roundedAmount = (baseAmount * 100).round() / 100;
    final remainder = totalAmount - (roundedAmount * numberOfParts);

    List<double> parts = List.filled(numberOfParts, roundedAmount);

    // Distribute remainder to first parts
    if (remainder != 0) {
      final remainderCents = (remainder * 100).round();
      for (int i = 0; i < remainderCents && i < numberOfParts; i++) {
        parts[i] += 0.01;
      }
    }

    return parts;
  }

  /// Calculate compound interest
  static double calculateCompoundInterest({
    required double principal,
    required double rate,
    required int compoundingPeriodsPerYear,
    required int years,
  }) {
    final ratePerPeriod = rate / compoundingPeriodsPerYear;
    final totalPeriods = compoundingPeriodsPerYear * years;
    return principal * pow(1 + ratePerPeriod, totalPeriods);
  }

  /// Calculate simple interest
  static double calculateSimpleInterest({
    required double principal,
    required double rate,
    required int years,
  }) {
    return principal * (1 + (rate * years));
  }

  /// Format percentage
  static String formatPercentage(
    double value, {
    int decimalPlaces = 1,
    String? locale,
  }) {
    final localeCode = locale ?? _defaultLocale;

    try {
      final formatter = NumberFormat.percentPattern(localeCode);
      formatter.minimumFractionDigits = decimalPlaces;
      formatter.maximumFractionDigits = decimalPlaces;
      return formatter.format(value / 100);
    } catch (e) {
      return '${value.toStringAsFixed(decimalPlaces)}%';
    }
  }

  /// Check if amount is valid
  static bool isValidAmount(double amount) {
    return amount.isFinite && !amount.isNaN && amount >= 0;
  }

  /// Compare currency amounts with precision
  static bool isAmountEqual(
    double amount1,
    double amount2, {
    int precision = 2,
  }) {
    final multiplier = pow(10, precision);
    return (amount1 * multiplier).round() == (amount2 * multiplier).round();
  }

  /// Get currency input formatter
  static List<TextInputFormatter> getCurrencyInputFormatter({
    String? currency,
    int? maxDigits,
  }) {
    final currencyCode = currency ?? _defaultCurrency;
    final decimals = getDecimalPlaces(currencyCode);

    return [
      FilteringTextInputFormatter.allow(
        RegExp(r'^\d+\.?\d{0,' + decimals.toString() + '}'),
      ),
      if (maxDigits != null) LengthLimitingTextInputFormatter(maxDigits),
    ];
  }

  /// Format currency for input field
  static String formatCurrencyInput(String input, {String? currency}) {
    final currencyCode = currency ?? _defaultCurrency;
    final amount = parseCurrency(input);

    if (amount == null) return input;

    return formatCurrency(amount, currency: currencyCode);
  }

  /// Calculate exchange rate
  static double calculateExchangeRate(double fromAmount, double toAmount) {
    if (fromAmount == 0) return 0;
    return toAmount / fromAmount;
  }

  /// Format price range
  static String formatPriceRange(
    double minPrice,
    double maxPrice, {
    String? currency,
    String? locale,
    bool showSymbol = true,
  }) {
    final currencyCode = currency ?? _defaultCurrency;

    if (minPrice == maxPrice) {
      return formatCurrency(
        minPrice,
        currency: currencyCode,
        locale: locale,
        showSymbol: showSymbol,
      );
    }

    final formattedMin = formatCurrency(
      minPrice,
      currency: currencyCode,
      locale: locale,
      showSymbol: showSymbol,
    );
    final formattedMax = formatCurrency(
      maxPrice,
      currency: currencyCode,
      locale: locale,
      showSymbol: showSymbol,
    );

    return '$formattedMin - $formattedMax';
  }

  /// Get all supported currencies
  static List<String> getSupportedCurrencies() {
    return _currencySymbols.keys.toList();
  }

  /// Check if currency is supported
  static bool isCurrencySupported(String currencyCode) {
    return _currencySymbols.containsKey(currencyCode.toUpperCase());
  }

  /// Private helper for compact formatting
  static String _formatCompact(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}

/// Currency conversion data class
class CurrencyConversion {
  final String fromCurrency;
  final String toCurrency;
  final double exchangeRate;
  final DateTime lastUpdated;

  const CurrencyConversion({
    required this.fromCurrency,
    required this.toCurrency,
    required this.exchangeRate,
    required this.lastUpdated,
  });

  double convert(double amount) {
    return CurrencyHelper.convertCurrency(amount, exchangeRate);
  }

  bool isExpired({Duration maxAge = const Duration(hours: 1)}) {
    return DateTime.now().difference(lastUpdated) > maxAge;
  }
}

/// Price calculation helper
class PriceCalculator {
  final double basePrice;
  final String currency;

  const PriceCalculator({required this.basePrice, this.currency = 'USD'});

  double withDiscount(double discountPercentage) {
    return CurrencyHelper.calculateDiscountedPrice(
      basePrice,
      discountPercentage,
    );
  }

  double withTax(double taxRate) {
    return CurrencyHelper.calculatePriceWithTax(basePrice, taxRate);
  }

  double withTip(double tipPercentage) {
    return CurrencyHelper.calculateTotalWithTip(basePrice, tipPercentage);
  }

  double withDiscountAndTax(double discountPercentage, double taxRate) {
    final discountedPrice = withDiscount(discountPercentage);
    return CurrencyHelper.calculatePriceWithTax(discountedPrice, taxRate);
  }

  String format({bool showSymbol = true, bool showCode = false}) {
    return CurrencyHelper.formatCurrency(
      basePrice,
      currency: currency,
      showSymbol: showSymbol,
      showCode: showCode,
    );
  }
}

/// Currency input validator
class CurrencyInputValidator {
  final String currency;
  final double? minAmount;
  final double? maxAmount;

  const CurrencyInputValidator({
    this.currency = 'USD',
    this.minAmount,
    this.maxAmount,
  });

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = CurrencyHelper.parseCurrency(value);
    if (amount == null) {
      return 'Invalid amount format';
    }

    if (!CurrencyHelper.isValidAmount(amount)) {
      return 'Invalid amount';
    }

    if (minAmount != null && amount < minAmount!) {
      return 'Amount must be at least ${CurrencyHelper.formatCurrency(minAmount!, currency: currency)}';
    }

    if (maxAmount != null && amount > maxAmount!) {
      return 'Amount must not exceed ${CurrencyHelper.formatCurrency(maxAmount!, currency: currency)}';
    }

    return null;
  }
}
