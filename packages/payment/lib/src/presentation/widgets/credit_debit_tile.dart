import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class CreditDebitTile extends StatelessWidget {
  const CreditDebitTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StripeCubit, StripeState>(
      builder: (context, state) {
        bool loading = state.status == StripeStatus.loading;

        return ListTile(
          leading: SvgIcon(name: 'credit-card'),
          title: Text('Credit/Debit Card'),
          trailing: SvgIcon(name: 'chevron-right'),
          onTap:
              loading
                  ? null
                  : () {
                    context.read<StripeCubit>().saveCardMethod();
                  },
        );
      },
    );
  }
}
