import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/location/domain/entities/currency_entity.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/credits/payment_credits_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/credits/payment_credits_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class PaymentCredits extends StatelessWidget {
  const PaymentCredits({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCreditsCubit>(
      create: (_) => serviceLocator<PaymentCreditsCubit>(),
      child: _PaymentCreditsView(key: key),
    );
  }
}

class _PaymentCreditsView extends StatefulWidget {
  const _PaymentCreditsView({super.key});

  @override
  State<_PaymentCreditsView> createState() => __PaymentCreditsViewState();
}

class __PaymentCreditsViewState extends State<_PaymentCreditsView> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCreditsCubit>().fetchCredits();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationServiceCubit, LocationServiceState>(
      builder: (context, state) {
        final var currency = state.currency;

        return BlocBuilder<PaymentCreditsCubit, PaymentCreditsState>(
          builder: (context, state) {
            final var loading = state.status == PaymentCreditsStatus.loading;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Muvmnt Credits',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (loading) ...[const CircularProgressIndicator.adaptive()],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Credits will automatically apply to future orders.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 10),
                  child: Text(
                    state.credits != null
                        ? '${currency?.symbol ?? ''}${state.credits?.credits.toStringAsFixed(2)} ${currency?.code ?? ''}'
                        : '${currency?.symbol ?? ''}0.00 ${currency?.code ?? ''}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Invite friends to earn credits',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: SvgIcon(name: 'chevron-right'),
                  onTap: () => context.push('/referral'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
