import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';

enum SavedAddressesStatus {
  initial,
  loading,
  loadingLabeled,
  updating,
  updatingLabeled,
  success,
  updated,
  error,
}

class SavedAddressesState extends Equatable {
  final SavedAddressesStatus status;
  final List<AddressEntity> addresses;
  final List<AddressEntity> labelledAddresses;
  final String? errorMessage;

  const SavedAddressesState({
    this.status = SavedAddressesStatus.initial,
    this.addresses = const [],
    this.labelledAddresses = const [],
    this.errorMessage,
  });

  SavedAddressesState copyWith({
    SavedAddressesStatus? status,
    List<AddressEntity>? addresses,
    List<AddressEntity>? labelledAddresses,
    List<AddressEntity>? unlabelledAddresses,
    String? errorMessage,
  }) {
    return SavedAddressesState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      labelledAddresses: labelledAddresses ?? this.labelledAddresses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    addresses,
    labelledAddresses,
    errorMessage,
  ];
}
