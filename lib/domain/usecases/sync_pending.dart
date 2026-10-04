import '../repositories/intervention_repository.dart';

class SyncPending {
  final InterventionRepository repository;
  SyncPending(this.repository);

  Future<void> call() => repository.syncPending();
}
