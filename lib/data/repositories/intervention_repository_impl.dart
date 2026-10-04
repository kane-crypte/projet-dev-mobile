import 'dart:convert';

import '../../domain/entities/intervention.dart';
import '../../domain/repositories/intervention_repository.dart';
import '../datasources/intervention_local_datasource.dart';
import '../datasources/intervention_remote_datasource.dart';
import '../mappers/intervention_mapper.dart';
import '../models/intervention_model.dart';

class InterventionRepositoryImpl implements InterventionRepository {
  final InterventionRemoteDataSource remote;
  final InterventionLocalDataSource local;

  InterventionRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Intervention>> getInterventions() async {
    try {
      final fresh = await remote.fetchAll();
      await local.saveAll(fresh); // on met le cache à jour
    } catch (_) {
      // hors-ligne : on utilise simplement les données locales
    }
    final models = await local.getAll();
    return models.map(InterventionMapper.toEntity).toList();
  }

  @override
  Future<void> updateIntervention(Intervention intervention) async {
    final model = InterventionMapper.toModel(intervention);
    await local.save(model); // 1. toujours en local d'abord
    try {
      await remote.update(model); // 2. on tente l'envoi
    } catch (_) {
      await local.enqueue(model); // 3. sinon, file d'attente
    }
  }

  @override
  Future<void> syncPending() async {
    final queue = await local.getQueue();
    for (final item in queue) {
      try {
        final model = InterventionModel.fromJson(
          jsonDecode(item['payload'] as String) as Map<String, dynamic>,
        );
        await remote.update(model);
        await local.removeFromQueue(item['queue_id'] as int);
      } catch (_) {
        break; // toujours hors-ligne : on réessaiera plus tard
      }
    }
  }
}
