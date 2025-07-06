import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  final String countryCode;
  final String number;
  final bool verified;

  const PhoneNumber({
    required this.countryCode,
    required this.number,
    required this.verified,
  });

  String get fullNumber => '$countryCode$number';

  @override
  List<Object?> get props => [countryCode, number];

  factory PhoneNumber.fromString(String countryCode, String number) {
    return PhoneNumber(
      countryCode: countryCode,
      number: number,
      verified: false,
    );
  }

  factory PhoneNumber.empty() {
    return PhoneNumber(countryCode: '', number: '', verified: false);
  }

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      countryCode: json['country_code'] ?? '',
      number: json['number'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'country_code': countryCode, 'number': number};
  }

  @override
  String toString() => fullNumber;
}

class Email extends Equatable {
  final String address;
  final bool verified;

  const Email({required this.address, required this.verified});

  @override
  List<Object?> get props => [address, verified];

  factory Email.empty() {
    return Email(address: '', verified: false);
  }

  factory Email.fromString(String email) {
    return Email(address: email, verified: false);
  }

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      address: json['address'] ?? '',
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'address': address};
  }
}

class Rating extends Equatable {
  final int count;
  final double average;

  const Rating({required this.count, required this.average});

  @override
  List<Object?> get props => [count, average];

  factory Rating.empty() {
    return Rating(count: 0, average: 0);
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      count: json['count'] as int,
      average: (json['average'] as int).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'count': count, 'average': average};
  }
}
