import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/create_paypal_payment_token.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/get_paypal_methods_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/remove_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/paypal/setup_paypal_token_usecase.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_state.dart';

class PaypalCubit extends Cubit<PaypalState> {
  final GetPaypalMethodsUseCase getPaypalMethodsUseCase;
  final SetupPaypalTokenUseCase setupPaypalMethodUseCase;
  final CreatePaypalPaymentTokenUseCase createPaypalPaymentTokenUseCase;
  final RemovePaypalPaymentMethodUseCase removePaypalPaymentMethodUseCase;

  PaypalCubit({
    required this.getPaypalMethodsUseCase,
    required this.setupPaypalMethodUseCase,
    required this.createPaypalPaymentTokenUseCase,
    required this.removePaypalPaymentMethodUseCase,
  }) : super(const PaypalState());

  Future<void> retrievePaypalMethods() async {
    emit(state.copyWith(status: PaypalStatus.loading));
    final result = await getPaypalMethodsUseCase();

    if (result is DataSuccess) {
      emit(state.copyWith(status: PaypalStatus.success, methods: result.data!));
    } else {
      emit(
        state.copyWith(
          status: PaypalStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> setupPaypalInitiated() async {
    emit(state.copyWith(status: PaypalStatus.settingUp));
    final result = await setupPaypalMethodUseCase();
    if (result is DataSuccess) {
      if (result.data == null) {
        emit(
          state.copyWith(
            status: PaypalStatus.failure,
            errorMessage: result.error?.message ?? 'Failed to setup',
          ),
        );
        return;
      }

      var setupTokenData = result.data;

      String? tokenId = setupTokenData!['tokenId'];
      String? approvalUrl = setupTokenData['approvalUrl'];

      emit(
        state.copyWith(
          status: PaypalStatus.success,
          setupTokenId: tokenId,
          approvalUrl: approvalUrl,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PaypalStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> createPaymentToken(String tokenId) async {
    emit(state.copyWith(status: PaypalStatus.settingUp));
    final result = await createPaypalPaymentTokenUseCase(tokenId);

    if (result is DataSuccess) {
      final updated = [...state.methods, result.data!];
      emit(state.copyWith(status: PaypalStatus.success, methods: updated));
    } else {
      emit(
        state.copyWith(
          status: PaypalStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> removePaymentMethod(String methodId) async {
    emit(state.copyWith(status: PaypalStatus.loading));

    final updated = state.methods.where((m) => m.id != methodId).toList();
    emit(state.copyWith(methods: updated, status: PaypalStatus.success));

    await removePaypalPaymentMethodUseCase(methodId);
  }
}
