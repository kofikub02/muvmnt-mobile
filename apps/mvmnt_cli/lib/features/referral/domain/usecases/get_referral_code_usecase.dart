import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/repository/referral_repository.dart';

class GetReferralCodeUseCase {
  final ReferralRepository repository;

  GetReferralCodeUseCase(this.repository);

  Future<DataState<ReferralCodeEntity>> call() async {
    return await repository.getReferralCode();
  }
}
