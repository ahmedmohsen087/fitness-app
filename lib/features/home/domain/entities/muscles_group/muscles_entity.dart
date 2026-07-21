import 'package:equatable/equatable.dart';

class MusclesEntity extends Equatable{

  final String id;
  final String name;
  const MusclesEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
    id,
    name
  ];

}