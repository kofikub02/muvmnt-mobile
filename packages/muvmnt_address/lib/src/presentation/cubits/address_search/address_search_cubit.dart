import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/get_address_from_geocode_usecase.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/get_geocode_from_address.dart';
import 'package:mvmnt_cli/features/addresses/domain/usecases/search/search_address_usecase.dart';
import 'package:mvmnt_cli/features/addresses/presentation/cubits/address_search/address_search_state.dart';

class AddressSearchCubit extends Cubit<AddressSearchState> {

  AddressSearchCubit({
    required this.searchAddressUseCase,
    required this.getGeocodeFromAddressUsecase,
    required this.getAddressFromGeocodeUsecase,
  }) : super(const AddressSearchState());
  static const _debounceDuration = Duration(milliseconds: 300);

  final SearchAddressUseCase searchAddressUseCase;
  final GetGeocodeFromAddressUseCase getGeocodeFromAddressUsecase;
  final GetAddressFromGeocodeUsecase getAddressFromGeocodeUsecase;
  Timer? _debounce;

  void clear() {
    emit(state.copyWith(query: '', addressSuggestions: []));
  }

  void updateQuery(String query, String? country) {
    emit(state.copyWith(query: query));

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      searchAddresses(query, country);
    });
  }

  Future<void> searchAddresses(String query, String? country) async {
    if (query.isEmpty || query.length < 3) {
      emit(
        state.copyWith(
          status: AddressSearchStatus.initial,
          addressSuggestions: [],
        ),
      );
      return;
    }

    emit(state.copyWith(status: AddressSearchStatus.loading));

    final result = await searchAddressUseCase(query, country);

    if (result is DataSuccess && result.data != null) {
      emit(
        state.copyWith(
          status: AddressSearchStatus.success,
          addressSuggestions: result.data,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AddressSearchStatus.error,
          errorMessage: result.error.toString(),
        ),
      );
    }
  }

  Future<void> selectAddress(
    AddressPredictionEntity selectedSuggestedAddress,
  ) async {
    emit(state.copyWith(status: AddressSearchStatus.loading));

    try {
      final result = await getGeocodeFromAddressUsecase(
        address: selectedSuggestedAddress.description,
      );

      if (result is DataFailed || result.data == null) {
        emit(
          state.copyWith(
            status: AddressSearchStatus.error,
            errorMessage: result.error?.toString() ?? 'Failed to get geocode',
          ),
        );
        return;
      }

      final selectedSuggestionGeocode = result.data;

      final newAddress = AddressEntity.empty().copyWith(
        description: selectedSuggestedAddress.description,
        mainText: selectedSuggestedAddress.mainText,
        secondaryText: selectedSuggestedAddress.secondaryText,
        lat: selectedSuggestionGeocode!.lat,
        lng: selectedSuggestionGeocode.lng,
      );

      emit(
        state.copyWith(
          status: AddressSearchStatus.success,
          selectedAddress: newAddress,
          addressSuggestions: [],
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddressSearchStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const AddressSearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
