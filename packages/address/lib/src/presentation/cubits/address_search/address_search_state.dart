import 'package:equatable/equatable.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';

enum AddressSearchStatus { initial, loading, success, error }

class AddressSearchState extends Equatable {
  final AddressSearchStatus status;
  final List<AddressPredictionEntity> addressSuggestions;
  final String query;
  final AddressEntity? selectedAddress;
  final String? errorMessage;

  const AddressSearchState({
    this.status = AddressSearchStatus.initial,
    this.addressSuggestions = const [],
    this.query = '',
    this.errorMessage,
    this.selectedAddress,
  });

  AddressSearchState copyWith({
    AddressSearchStatus? status,
    List<AddressPredictionEntity>? addressSuggestions,
    AddressEntity? selectedAddress,
    String? query,
    String? errorMessage,
  }) {
    return AddressSearchState(
      status: status ?? this.status,
      addressSuggestions: addressSuggestions ?? this.addressSuggestions,
      query: query ?? this.query,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    addressSuggestions,
    query,
    selectedAddress,
    errorMessage,
  ];
}
