import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final String? errorMessage;
  final ProfileEntity? profileEntity;

  const ProfileState._({
    required this.status,
    this.errorMessage,
    this.profileEntity,
  });

  factory ProfileState.initial() =>
      ProfileState._(status: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? status,
    String? errorMessage,
    ProfileEntity? profileEntity,
  }) => ProfileState._(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    profileEntity: profileEntity ?? this.profileEntity,
  );

  @override
  List<Object?> get props => [status, errorMessage, profileEntity];
}
