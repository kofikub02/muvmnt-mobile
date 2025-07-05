import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/credits/get_payment_credits_usecase.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/credits/payment_credits_state.dart';

class PaymentCreditsCubit extends Cubit<PaymentCreditsState> {

  PaymentCreditsCubit({required this.getPaymentCreditsUseCase})
    : super(const PaymentCreditsState());
  final GetPaymentCreditsUseCase getPaymentCreditsUseCase;

  Future<void> fetchCredits() async {
    emit(state.copyWith(status: PaymentCreditsStatus.loading));
    final result = await getPaymentCreditsUseCase();
    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: PaymentCreditsStatus.loaded,
          credits: result.data,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PaymentCreditsStatus.error,
          errorMessage: result.error?.toString() ?? 'Unknown error',
        ),
      );
    }
  }
}
