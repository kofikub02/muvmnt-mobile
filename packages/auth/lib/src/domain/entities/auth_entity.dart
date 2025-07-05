import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final bool isAnonymous;

  const AuthEntity({this.id, this.isAnonymous = true});

  @override
  List<Object?> get props => [id, isAnonymous];
}
