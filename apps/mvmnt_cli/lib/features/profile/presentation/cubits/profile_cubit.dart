import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:mvmnt_cli/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;

  ProfileCubit({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileState.initial());

  Future<void> getProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, profileEntity: null));

    final result = await getProfileUsecase();

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profileEntity: result.data,
        ),
      );
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: result.error!.message ?? 'Failed to load profile',
        ),
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileUpdate) async {
    if (profileUpdate.isEmpty) {
      return;
    }

    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await updateProfileUsecase(
      id: state.profileEntity?.id,
      profileUpdateEntity: profileUpdate,
    );

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profileEntity: result.data,
        ),
      );
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: result.error!.message ?? 'Failed to create profile',
        ),
      );
    }
  }
}
