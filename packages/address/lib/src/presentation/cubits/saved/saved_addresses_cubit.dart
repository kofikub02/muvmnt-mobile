import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/add_to_address_history_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/delete_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/get_address_history_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/get_labelled_addresses_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/save_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/saved/update_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/saved/saved_addresses_state.dart';

import 'package:mvmnt_cli/core/resources/data_state.dart';

var emptyHome = AddressEntity.empty().copyWith(
  icon: 'home',
  label: 'home',
  description: 'Set Address',
);

var emptyWork = AddressEntity.empty().copyWith(
  icon: 'work',
  label: 'work',
  description: 'Set Address',
);

class SavedAddressesCubit extends Cubit<SavedAddressesState> {

  SavedAddressesCubit({
    required this.getLabelledAddressesUsecase,
    required this.getSavedAddressesUsecase,
    required this.saveAddressUsecase,
    required this.addToAddressesHistoryUseCase,
    required this.updateAddressUseCase,
    required this.deleteSavedAddressUsecase,
  }) : super(const SavedAddressesState()) {
    emit(state.copyWith(labelledAddresses: [emptyHome, emptyWork]));
  }
  final GetLabelledAddressesUsecase getLabelledAddressesUsecase;
  final GetAddressHistoryUsecase getSavedAddressesUsecase;
  final SaveAddressUsecase saveAddressUsecase;
  final AddToAddressesHistoryUseCase addToAddressesHistoryUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteSavedAddressUsecase;

  Future<void> loadLabeledAddresses() async {
    emit(state.copyWith(status: SavedAddressesStatus.loadingLabeled));
    final labeledResult = await getLabelledAddressesUsecase();
    if (labeledResult is DataSuccess<List<AddressEntity>>) {
      final labeled = labeledResult.data ?? [];
      emit(
        state.copyWith(
          status: SavedAddressesStatus.success,
          labelledAddresses: _rearrangeLabelled(labeled),
          errorMessage: null,
        ),
      );
    } else if (labeledResult is DataFailed) {
      emit(
        state.copyWith(
          status: SavedAddressesStatus.error,
          errorMessage: labeledResult.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> loadSavedAddresses() async {
    emit(state.copyWith(status: SavedAddressesStatus.loading));
    final historyResult = await getSavedAddressesUsecase();

    if (historyResult is DataSuccess<List<AddressEntity>>) {
      final addresses = historyResult.data ?? [];

      emit(
        state.copyWith(
          status: SavedAddressesStatus.success,
          addresses: addresses,
          errorMessage: null,
        ),
      );
    } else if (historyResult is DataFailed) {
      emit(
        state.copyWith(
          status: SavedAddressesStatus.error,
          errorMessage: historyResult.error?.message ?? '',
        ),
      );
    }
  }

  Future<void> addToAddressHistory(AddressEntity address) async {
    emit(state.copyWith(status: SavedAddressesStatus.updating));
    final result = await addToAddressesHistoryUseCase(address);

    if (result is DataSuccess) {
      await loadSavedAddresses();
    } else {
      emit(
        state.copyWith(
          status: SavedAddressesStatus.error,
          errorMessage: result.error?.message ?? 'Failed to add address',
        ),
      );
    }
  }

  Future<void> saveAddress(AddressEntity address) async {
    emit(state.copyWith(status: SavedAddressesStatus.updatingLabeled));
    final result = await saveAddressUsecase(address);

    if (result is DataSuccess) {
      final labeled = result.data;

      emit(
        state.copyWith(
          status: SavedAddressesStatus.success,
          labelledAddresses: _rearrangeLabelled([
            labeled,
            ...state.labelledAddresses,
          ]),
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SavedAddressesStatus.error,
          errorMessage: result.error?.message ?? 'Failed to add address',
        ),
      );
    }
  }

  Future<void> updateAddress(AddressEntity address) async {
    emit(state.copyWith(status: SavedAddressesStatus.loading));
    final result = await updateAddressUseCase(address);

    if (result is DataSuccess<AddressEntity?>) {
      final updatedAddress = result.data;

      if (updatedAddress == null) {
        return;
      }

      if (state.labelledAddresses.any((a) => a.id == updatedAddress.id) ||
          (updatedAddress.label != null && updatedAddress.label!.isNotEmpty)) {
        final labelled = [
          updatedAddress,
          ...state.labelledAddresses.where((a) => a.id != updatedAddress.id),
        ];
        emit(state.copyWith(labelledAddresses: _rearrangeLabelled(labelled)));
      }

      await loadSavedAddresses();
    } else {
      emit(
        state.copyWith(
          status: SavedAddressesStatus.error,
          errorMessage: result.error?.message ?? 'Failed to add address',
        ),
      );
    }
  }

  Future<void> removeAddress(String id) async {
    emit(state.copyWith(status: SavedAddressesStatus.loading));

    final address = state.labelledAddresses.firstWhere(
      (a) => a.id == id,
      orElse: AddressEntity.empty,
    );

    final updated = state.addresses.where((a) => a.id != id).toList();
    emit(state.copyWith(addresses: updated, errorMessage: null));

    final labelled = state.labelledAddresses.where((a) => a.id != id).toList();
    emit(state.copyWith(labelledAddresses: _rearrangeLabelled(labelled)));

    final isLabelled = address.label?.isNotEmpty ?? false;

    await deleteSavedAddressUsecase(id, isLabelled);
  }

  List<AddressEntity> _rearrangeLabelled(List<AddressEntity> labelled) {
    var rearranged = <AddressEntity>[];

    final homeAddress = labelled.firstWhere(
      (a) => a.label?.toLowerCase() == 'home',
      orElse: () => emptyHome,
    );

    final workAddress = labelled.firstWhere(
      (a) => a.label?.toLowerCase() == 'work',
      orElse: () => emptyWork,
    );

    // Add home and work first
    rearranged.add(homeAddress);
    rearranged.add(workAddress);

    // Add others except home and work
    rearranged.addAll(
      labelled.where(
        (a) =>
            a.label?.toLowerCase() != 'home' &&
                a.label?.toLowerCase() != 'work',
      ),
    );

    return rearranged;
  }
}
