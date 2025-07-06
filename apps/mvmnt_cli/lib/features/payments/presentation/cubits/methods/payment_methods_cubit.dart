import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/local/available_local_methods.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_method_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/get_active_payment_methods.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/remove_saved_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/domain/usecases/methods/save_payment_method_usecase.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/methods/payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final GetActivePaymentMethodTypesUseCase getActivePaymentMethodTypesUseCase;
  final SavePaymentMethodTypeUseCase savePaymentMethodTypeUseCase;
  final RemovePaymentMethodTypeUseCase removePaymentMethodTypeUseCase;

  PaymentMethodsCubit({
    required this.getActivePaymentMethodTypesUseCase,
    required this.savePaymentMethodTypeUseCase,
    required this.removePaymentMethodTypeUseCase,
  }) : super(const PaymentMethodsState());

  Future<void> loadLocalMethods() async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading));
    final result = await getActivePaymentMethodTypesUseCase();

    if (result is DataSuccess) {
      if (result.data == null) {
        return;
      }

      emit(
        state.copyWith(
          status: PaymentMethodsStatus.success,
          activeMethodTypes:
              availableLocalPaymentMethods
                  .where((method) => result.data!.contains(method.type))
                  .toList(),
          availableMethodTypes:
              availableLocalPaymentMethods
                  .where(
                    (method) =>
                        !(method.type == PaymentMethodType.googlepay ||
                            (method.type == PaymentMethodType.applepay &&
                                !TDeviceUtils.isIOS())),
                  )
                  .where((method) => !result.data!.contains(method.type))
                  .toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PaymentMethodsStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> saveMethodType(PaymentMethodEntity method) async {
    emit(state.copyWith(status: PaymentMethodsStatus.adding));
    final result = await savePaymentMethodTypeUseCase(method.type);

    if (result is DataFailed) {
      emit(
        state.copyWith(
          status: PaymentMethodsStatus.failure,
          errorMessage: result.error?.message ?? '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PaymentMethodsStatus.updated,
          activeMethodTypes: List<PaymentMethodEntity>.from(
            state.activeMethodTypes,
          )..add(method),
          availableMethodTypes:
              state.availableMethodTypes
                  .where((m) => m.type != method.type)
                  .toList(),
        ),
      );
    }
  }

  Future<void> removeMethodType(PaymentMethodType paymentMethodType) async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading));

    emit(
      state.copyWith(
        status: PaymentMethodsStatus.success,
        activeMethodTypes:
            state.activeMethodTypes
                .where((m) => m.type != paymentMethodType)
                .toList(),
        availableMethodTypes:
            state.availableMethodTypes..add(
              state.activeMethodTypes.firstWhere(
                (m) => m.type == paymentMethodType,
              ),
            ),
      ),
    );

    await removePaymentMethodTypeUseCase(paymentMethodType);
  }
}
