import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_state.dart';
import 'package:mvmnt_cli/features/payments/presentation/widgets/paypal_tile.dart';
import 'package:mvmnt_cli/features/payments/presentation/widgets/saved_payment_methods.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/features/payments/presentation/widgets/payment_credits.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_state.dart';
import 'package:mvmnt_cli/features/payments/presentation/widgets/credit_debit_tile.dart';
import 'package:mvmnt_cli/features/payments/presentation/widgets/mobile_money_tile.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static const String route = '/payments';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentPaymentCubit>().getDefaultPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Payment'),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CurrentPaymentCubit, CurrentPaymentState>(
                  builder: (context, state) {
                    return SavedPaymentMethods(
                      currentPaymentMethodId: state.currentMethod?.id,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                CreditDebitTile(),
                MobileMoneyTile(),
                PaypalTile(),
                BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        ...state.availableMethodTypes
                                .map(
                                  (method) => ListTile(
                                    leading: SvgIcon(
                                      name: method.icon,
                                      hasIntrinsic: true,
                                    ),
                                    title: Text(method.name.toCapitalized),
                                    trailing: SvgIcon(name: 'chevron-right'),
                                    onTap: () {
                                      context
                                          .read<PaymentMethodsCubit>()
                                          .saveMethodType(method);
                                      context
                                          .read<CurrentPaymentCubit>()
                                          .setDefaultPaymentMethod(method);
                                    },
                                  ),
                                )
                                .toList()
                            as List<Widget>,
                      ],
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(thickness: 0.2),
                ),
                SizedBox(height: 8),
                PaymentCredits(),
                SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
