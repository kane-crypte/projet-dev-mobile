import '../../domain/entities/intervention.dart';

abstract class InterventionState {}

class InterventionLoading extends InterventionState {}

class InterventionLoaded extends InterventionState {
  final List<Intervention> items;
  InterventionLoaded(this.items);
}

class InterventionError extends InterventionState {
  final String message;
  InterventionError(this.message);
}
