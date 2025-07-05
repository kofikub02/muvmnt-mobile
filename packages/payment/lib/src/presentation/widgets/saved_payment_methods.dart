import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_state.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_state.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_state.dart';
import 'package:mvmnt_cli/ui/widgets/custom_dismissible.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class SavedPaymentMethods extends StatefulWidget {
  final String? currentPaymentMethodId;

  const SavedPaymentMethods({super.key, required this.currentPaymentMethodId});

  @override
  State<SavedPaymentMethods> createState() => _SavedPaymentMethodsState();
}

class _SavedPaymentMethodsState extends State<SavedPaymentMethods> {
  @override
  void initState() {
    super.initState();
    context.read<StripeCubit>().loadCardMethods();
    context.read<PaypalCubit>().retrievePaypalMethods();
    context.read<PaymentMethodsCubit>().loadLocalMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Saved Payment Methods',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        BlocBuilder<StripeCubit, StripeState>(
          builder: (context, state) {
            return Column(
              children: [
                ...state.cards.map(
                  (e) => _SavedPaymentMethodTile(
                    key: Key(e.id),
                    isDefault: (widget.currentPaymentMethodId ?? '') == e.id,
                    paymentMethod: e,
                    onRemove: () {
                      context.read<StripeCubit>().removeSavedMethod(e.id);
                    },
                  ),
                ),
              ],
            );
          },
        ),
        BlocBuilder<PaypalCubit, PaypalState>(
          builder: (context, state) {
            return Column(
              children: [
                ...state.methods.map(
                  (e) => _SavedPaymentMethodTile(
                    key: Key(e.id),
                    isDefault: (widget.currentPaymentMethodId ?? '') == e.id,
                    paymentMethod: e,
                    onRemove: () {
                      context.read<PaypalCubit>().removePaymentMethod(e.id);
                    },
                  ),
                ),
              ],
            );
          },
        ),
        BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
          builder: (context, state) {
            return Column(
              children: [
                ...state.activeMethodTypes.map(
                  (e) => _SavedPaymentMethodTile(
                    key: Key(e.name),
                    isDefault: (widget.currentPaymentMethodId ?? '') == e.id,
                    paymentMethod: e,
                    onRemove: () {
                      context.read<PaymentMethodsCubit>().removeMethodType(
                        e.type,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(thickness: 0.2),
        ),
      ],
    );
  }
}

class _SavedPaymentMethodTile extends StatelessWidget {
  final PaymentMethodEntity paymentMethod;
  final Function onRemove;
  final bool isDefault;

  const _SavedPaymentMethodTile({
    super.key,
    required this.paymentMethod,
    required this.isDefault,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDismissible(
      id: paymentMethod.id,
      isDismissible: isDefault,
      onDismissed: () {
        onRemove();
      },
      child: ListTile(
        leading: SvgIcon(name: paymentMethod.icon, hasIntrinsic: true),
        title: Text(paymentMethod.name.toCapitalized),
        subtitle:
            paymentMethod.meta == null || paymentMethod.meta!.isEmpty
                ? null
                : Text(paymentMethod.meta!, style: TextStyle(fontSize: 12)),
        trailing: isDefault ? SvgIcon(name: 'check') : null,
        onTap: () {
          context.read<CurrentPaymentCubit>().setDefaultPaymentMethod(
            paymentMethod,
          );
        },
      ),
    );
  }
}
