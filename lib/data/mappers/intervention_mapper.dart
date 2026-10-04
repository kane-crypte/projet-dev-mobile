import '../../domain/entities/intervention.dart';
import '../models/intervention_model.dart';

class InterventionMapper {
  static Intervention toEntity(InterventionModel m) => Intervention(
    id: m.id,
    client: m.client,
    address: m.address,
    description: m.description,
    equipment: m.equipment,
    status: InterventionStatus.values.firstWhere(
      (s) => s.name == m.status,
      orElse: () => InterventionStatus.pending,
    ),
    priority: m.priority,
    lat: m.lat,
    lng: m.lng,
    notes: m.notes,
    photos: m.photos,
    signaturePath: m.signaturePath,
  );

  static InterventionModel toModel(Intervention e) => InterventionModel(
    id: e.id,
    client: e.client,
    address: e.address,
    description: e.description,
    equipment: e.equipment,
    status: e.status.name,
    priority: e.priority,
    lat: e.lat,
    lng: e.lng,
    notes: e.notes,
    photos: e.photos,
    signaturePath: e.signaturePath,
  );
}
