import 'package:equatable/equatable.dart';

class AddressPredictionEntity extends Equatable {
  final String description;
  final String mainText;
  final String secondaryText;

  const AddressPredictionEntity({
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  @override
  List<Object?> get props => [description, mainText, secondaryText];
}
