import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_interventions.dart';
import 'intervention_state.dart';

class InterventionCubit extends Cubit<InterventionState> {
  final GetInterventions getInterventions;

  InterventionCubit(this.getInterventions) : super(InterventionLoading());

  Future<void> load() async {
    emit(InterventionLoading());
    try {
      final items = await getInterventions();
      emit(InterventionLoaded(items));
    } catch (e) {
      emit(InterventionError(e.toString()));
    }
  }
}
