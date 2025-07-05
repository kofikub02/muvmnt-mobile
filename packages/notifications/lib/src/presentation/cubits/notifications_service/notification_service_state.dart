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
  final String message;

  const NotificationServiceError({required this.message});

  @override
  List<Object?> get props => [message];
}
