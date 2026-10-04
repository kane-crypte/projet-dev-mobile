import 'dart:convert';

class InterventionModel {
  final int id;
  final String client;
  final String address;
  final String description;
  final String equipment;
  final String status; // pending | inProgress | done
  final int priority;
  final double lat;
  final double lng;
  final String? notes;
  final List<String> photos;
  final String? signaturePath;

  const InterventionModel({
    required this.id,
    required this.client,
    required this.address,
    required this.description,
    required this.equipment,
    required this.status,
    required this.priority,
    required this.lat,
    required this.lng,
    this.notes,
    this.photos = const [],
    this.signaturePath,
  });

  // JSON de l'API
  factory InterventionModel.fromJson(Map<String, dynamic> j) =>
      InterventionModel(
        id: j['id'] as int,
        client: j['client'] as String,
        address: j['address'] as String,
        description: j['description'] as String,
        equipment: j['equipment'] as String,
        status: j['status'] as String,
        priority: j['priority'] as int,
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        notes: j['notes'] as String?,
        photos: List<String>.from(j['photos'] ?? []),
        signaturePath: j['signaturePath'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client,
    'address': address,
    'description': description,
    'equipment': equipment,
    'status': status,
    'priority': priority,
    'lat': lat,
    'lng': lng,
    'notes': notes,
    'photos': photos,
    'signaturePath': signaturePath,
  };

  // Ligne SQLite (les photos sont stockées en texte JSON)
  factory InterventionModel.fromMap(Map<String, dynamic> m) =>
      InterventionModel(
        id: m['id'] as int,
        client: m['client'] as String,
        address: m['address'] as String,
        description: m['description'] as String,
        equipment: m['equipment'] as String,
        status: m['status'] as String,
        priority: m['priority'] as int,
        lat: (m['lat'] as num).toDouble(),
        lng: (m['lng'] as num).toDouble(),
        notes: m['notes'] as String?,
        photos: List<String>.from(jsonDecode(m['photos'] as String)),
        signaturePath: m['signature_path'] as String?,
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'client': client,
    'address': address,
    'description': description,
    'equipment': equipment,
    'status': status,
    'priority': priority,
    'lat': lat,
    'lng': lng,
    'notes': notes,
    'photos': jsonEncode(photos),
    'signature_path': signaturePath,
  };
}
