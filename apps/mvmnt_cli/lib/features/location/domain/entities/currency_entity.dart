class CurrencyEntity {
  final String code;
  final String symbol;

  const CurrencyEntity({required this.code, required this.symbol});

  factory CurrencyEntity.fromJson(Map<String, dynamic> json) {
    return CurrencyEntity(
      code: json['code'] as String,
      symbol: json['symbol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'symbol': symbol};
  }

  @override
  String toString() => 'CurrencyEntity(code: $code, symbol: $symbol)';
}
