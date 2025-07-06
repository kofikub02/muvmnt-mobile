import 'package:equatable/equatable.dart';

class AddressPredictionEntity extends Equatable {

  const AddressPredictionEntity({
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
  final String description;
  final String mainText;
  final String secondaryText;

  @override
  List<Object?> get props => [description, mainText, secondaryText];
}
