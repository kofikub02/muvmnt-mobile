import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/current/get_default_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/current/set_default_payment_method.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/current/current_payment_state.dart';

class CurrentPaymentCubit extends Cubit<CurrentPaymentState> {

  CurrentPaymentCubit({
    required this.setDefaultPaymentMethodUseCase,
    required this.getDefaultPaymentMethodUseCase,
  }) : super(const CurrentPaymentState());
  final GetDefaultPaymentMethodUseCase getDefaultPaymentMethodUseCase;
  final SetDefaultPaymentMethodUseCase setDefaultPaymentMethodUseCase;

  Future<void> getDefaultPaymentMethod() async {
    emit(state.copyWith(status: CurrentPaymentStatus.loading));
    final result = await getDefaultPaymentMethodUseCase();

    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: CurrentPaymentStatus.success,
          selectedMethodId: result.data,
        ),
      );
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: CurrentPaymentStatus.failure,
          errorMessage:
              result.error?.message ?? 'Failed to get default payment method',
        ),
      );
    }
  }

  Future<void> setDefaultPaymentMethod(
    PaymentMethodEntity paymentMethod,
  ) async {
    emit(state.copyWith(status: CurrentPaymentStatus.loading));
    final result = await setDefaultPaymentMethodUseCase(paymentMethod);
    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: CurrentPaymentStatus.success,
          selectedMethodId: paymentMethod,
        ),
      );
    } else if (result is DataFailed) {
      emit(
        state.copyWith(
          status: CurrentPaymentStatus.failure,
          errorMessage:
              result.error?.message ?? 'Failed to set default payment method',
        ),
      );
    }
  }
}
