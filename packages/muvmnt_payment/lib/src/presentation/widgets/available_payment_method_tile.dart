import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class AvailablePaymentMethodTile extends StatelessWidget {

  const AvailablePaymentMethodTile({super.key, required this.paymentMethod});
  final PaymentMethodEntity paymentMethod;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgIcon(name: paymentMethod.icon, hasIntrinsic: true),
      title: Text(paymentMethod.name.toCapitalized),
      trailing: SvgIcon(name: 'chevron-right'),
      onTap: () {
        context.read<PaymentMethodsCubit>().saveMethodType(paymentMethod);
        context.read<CurrentPaymentCubit>().setDefaultPaymentMethod(
          paymentMethod,
        );
      },
    );
  }
}
