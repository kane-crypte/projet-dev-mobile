import '../entities/intervention.dart';

abstract class InterventionRepository {
  Future<List<Intervention>> getInterventions();
  Future<void> updateIntervention(Intervention intervention);
  Future<void> syncPending();
}
