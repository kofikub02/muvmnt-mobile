import 'package:equatable/equatable.dart';

abstract class NotificationServiceState extends Equatable {
  const NotificationServiceState();

  @override
  List<Object?> get props => [];
}

class NotificationServiceInitial extends NotificationServiceState {}

class NotificationServiceLoading extends NotificationServiceState {}

class NotificationServiceInitialized extends NotificationServiceState {}

class NotificationServiceError extends NotificationServiceState {

  const NotificationServiceError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
