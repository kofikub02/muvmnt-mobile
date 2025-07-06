import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/repository/referral_repository.dart';

class GetIssuedReferralsUseCase {
  final ReferralRepository repository;

  GetIssuedReferralsUseCase(this.repository);

  Future<DataState<List<ReferralEntity>>> call() async {
    return await repository.getIssuedReferrals();
  }
}
