import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/referral/domain/usecases/get_issued_referrals_usecase.dart';
import 'package:mvmnt_cli/features/referral/domain/usecases/get_referral_code_usecase.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> {
  final GetReferralCodeUseCase getReferralCodeUseCase;
  final GetIssuedReferralsUseCase getIssuedReferralsUseCase;

  ReferralCubit({
    required this.getReferralCodeUseCase,
    required this.getIssuedReferralsUseCase,
  }) : super(ReferralState.initial());

  Future getReferralCode() async {
    emit(state.copyWith(status: ReferralStatus.loading));
    final result = await getReferralCodeUseCase();
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ReferralStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          referralCode: result.data,
          status: ReferralStatus.success,
          errorMessage: null,
        ),
      );
    }
  }

  Future getIssuedReferrals() async {
    if (state.issuedReferrals.isNotEmpty) {
      return;
    }

    emit(state.copyWith(status: ReferralStatus.loading));
    final result = await getIssuedReferralsUseCase();
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ReferralStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          issuedReferrals: result.data,
          status: ReferralStatus.success,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> onReloadIssuedReferrals() async {
    emit(state.copyWith(status: ReferralStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    final result = await getIssuedReferralsUseCase();
    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: ReferralStatus.error,
          errorMessage: result.error?.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          issuedReferrals: result.data,
          status: ReferralStatus.success,
          errorMessage: null,
        ),
      );
    }
  }
}
