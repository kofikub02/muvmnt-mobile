import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/core/util/date_util.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/referral/domain/entities/referral_entity.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_cubit.dart';
import 'package:mvmnt_cli/features/referral/presentation/cubits/referral_state.dart';
import 'package:mvmnt_cli/ui/shimmers/shimmer_list_tile.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class IssuedReferralsPage extends StatelessWidget {
  const IssuedReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReferralCubit>(
      create: (_) => serviceLocator<ReferralCubit>(),
      child: _IssuedReferralsView(key: key),
    );
  }
}

class _IssuedReferralsView extends StatefulWidget {
  const _IssuedReferralsView({super.key});

  @override
  State<_IssuedReferralsView> createState() => _IssuedReferralsViewState();
}

class _IssuedReferralsViewState extends State<_IssuedReferralsView> {
  @override
  void initState() {
    super.initState();
    context.read<ReferralCubit>().getIssuedReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Referral Status'),
      body: BlocBuilder<ReferralCubit, ReferralState>(
        builder: (context, state) {
          bool isLoading = state.status == ReferralStatus.loading;

          if (state.status != ReferralStatus.initial ||
              state.status != ReferralStatus.error) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ReferralCubit>().onReloadIssuedReferrals();
              },
              child: ListView.builder(
                itemCount: isLoading ? 1 : state.issuedReferrals.length,
                itemBuilder: (context, index) {
                  if (isLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 10,
                      ),
                      child: ShimmerListTile(),
                    );
                  }

                  var referral = state.issuedReferrals[index];
                  return ListTile(
                    leading: SvgIcon(name: 'people'),
                    title: Text(
                      '${referral.referredUser.firstName.toCapitalized} ${referral.referredUser.lastName.toCapitalized}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(buildDisplayText(referral)),
                  );
                },
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'To receive credits, your friend has to create a new account and place an order.',
            ),
          );
        },
      ),
    );
  }

  String buildDisplayText(ReferralEntity referral) {
    String formattedDate = formatDate(referral.updatedAt);
    return '${referral.status.toCapitalized} on $formattedDate for ${referral.referralCode.points} credits';
  }
}
