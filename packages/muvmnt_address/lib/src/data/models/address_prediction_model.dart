import 'package:mvmnt_cli/features/addresses/domain/entities/address_prediction_entity.dart';

class AddressPredictionModel extends AddressPredictionEntity {

  factory AddressPredictionModel.fromEntity(AddressPredictionEntity entity) {
    return AddressPredictionModel(
      description: entity.description,
      mainText: entity.mainText,
      secondaryText: entity.secondaryText,
    );
  }
  const AddressPredictionModel({
    required super.description,
    required super.mainText,
    required super.secondaryText,
  });

  factory AddressPredictionModel.fromJson(Map<String, dynamic> json) {
    final formatting = json['structured_formatting'] ?? {};
    return AddressPredictionModel(
      description: json['description'] ?? '',
      mainText: formatting['main_text'] ?? '',
      secondaryText: formatting['secondary_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'structured_formatting': {
        'main_text': mainText,
        'secondary_text': secondaryText,
      },
    };
  }

  AddressPredictionEntity toEntity() {
    return AddressPredictionEntity(
      description: description,
      mainText: mainText,
      secondaryText: secondaryText,
    );
  }
}
