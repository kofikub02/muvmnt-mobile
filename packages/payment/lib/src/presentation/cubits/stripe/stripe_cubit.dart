import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/get_card_methods_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/remove_card_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/stripe/save_card_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/stripe/stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {

  StripeCubit({
    required this.saveCardMethodUseCase,
    required this.getCardMethodsUseCase,
    required this.removeCardMethodUseCase,
  }) : super(const StripeState());
  final SaveCardMethodUseCase saveCardMethodUseCase;
  final GetCardMethodsUseCase getCardMethodsUseCase;
  final RemoveCardMethodUseCase removeCardMethodUseCase;

  Future<void> loadCardMethods() async {
    emit(state.copyWith(status: StripeStatus.loading));
    final result = await getCardMethodsUseCase();

    if (result is DataSuccess) {
      emit(state.copyWith(status: StripeStatus.success, cards: result.data));
    } else {
      emit(
        state.copyWith(
          status: StripeStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> saveCardMethod() async {
    emit(state.copyWith(status: StripeStatus.loading));
    final result = await saveCardMethodUseCase();

    if (result is DataSuccess) {
      await loadCardMethods();
    } else {
      emit(
        state.copyWith(
          status: StripeStatus.failure,
          errorMessage: result.error?.message ?? 'Failed to save card',
        ),
      );
    }
  }

  Future<void> removeSavedMethod(String paymentMethodId) async {
    emit(state.copyWith(status: StripeStatus.loading));

    final updated = state.cards.where((m) => m.id != paymentMethodId).toList();
    emit(state.copyWith(cards: updated, status: StripeStatus.success));

    await removeCardMethodUseCase(paymentMethodId);
  }
}
