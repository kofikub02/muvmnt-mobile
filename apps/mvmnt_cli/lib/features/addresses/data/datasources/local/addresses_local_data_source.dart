// ignore_for_file: prefer_conditional_assignment

import 'package:hive/hive.dart';
import 'package:mvmnt_cli/features/addresses/data/models/address_model.dart';

class AddressLocalDataSource {
  static const _boxName = 'addresses';
  Box<AddressModel>? _box;

  Future<void> init(String uid) async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
    await Hive.openBox<AddressModel>("$uid$_boxName");
    _box = Hive.box<AddressModel>("$uid$_boxName");
  }

  Box<AddressModel> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Box has not been initialized or is closed.');
    }
    return _box!;
  }

  Future<void> saveAddress(AddressModel model) async {
    dynamic existingKey;

    if (model.label != null && model.label!.isNotEmpty) {
      existingKey = box.keys.firstWhere(
        (key) => box.get(key)?.label == model.label,
        orElse: () => null,
      );
    }

    if (existingKey == null) {
      existingKey = box.keys.firstWhere(
        (key) => box.get(key)?.id == model.id,
        orElse: () => null,
      );
    }

    if (existingKey == null) {
      existingKey ??= box.keys.firstWhere(
        (key) =>
            box.get(key)?.mainText == model.mainText &&
            box.get(key)?.secondaryText == model.secondaryText,
        orElse: () => null,
      );
    }

    if (existingKey != null) {
      await box.delete(existingKey);
    } else {
      // If there are already 7 addresses, try to delete a non-labelled one
      final allAddresses = box.keys.toList();
      if (allAddresses.length >= 7) {
        final nonLabelledKey = allAddresses.firstWhere((key) {
          final address = box.get(key);
          return address?.label == null || address!.label!.isEmpty;
        }, orElse: () => null);

        if (nonLabelledKey != null) {
          await box.delete(nonLabelledKey);
        }
      }
    }

    await box.add(model);
  }

  Future<List<AddressModel>> getAddresses() async {
    final list = box.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  Future<AddressModel?> updateAddress(AddressModel model) async {
    dynamic existingKey;

    if (model.label != null && model.label!.isNotEmpty) {
      existingKey = box.keys.firstWhere(
        (key) => box.get(key)?.label == model.label,
        orElse: () => null,
      );

      if (existingKey != null) {
        await box.delete(existingKey);
      }
    }

    existingKey = box.keys.firstWhere(
      (key) => box.get(key)?.id == model.id,
      orElse: () => null,
    );

    if (existingKey != null) {
      await box.put(existingKey, model);
    } else {
      await box.add(model);
    }

    return model;
  }

  Future<void> deleteAddress(String id) async {
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key)?.id == id,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }
}
