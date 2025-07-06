import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_code_entity.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';

abstract class ReferralRepository {
  Future<DataState<ReferralCodeEntity>> getReferralCode();
  Future<DataState<List<ReferralEntity>>> getIssuedReferrals();
}
