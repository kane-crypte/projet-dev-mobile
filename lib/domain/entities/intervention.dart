import 'package:equatable/equatable.dart';

enum InterventionStatus { pending, inProgress, done }

class Intervention extends Equatable {
  final int id;
  final String client;
  final String address;
  final String description;
  final String equipment;
  final InterventionStatus status;
  final int priority;
  final double lat;
  final double lng;
  final String? notes;
  final List<String> photos;
  final String? signaturePath;

  const Intervention({
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

  Intervention copyWith({
    InterventionStatus? status,
    String? notes,
    List<String>? photos,
    String? signaturePath,
  }) => Intervention(
    id: id,
    client: client,
    address: address,
    description: description,
    equipment: equipment,
    priority: priority,
    lat: lat,
    lng: lng,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    photos: photos ?? this.photos,
    signaturePath: signaturePath ?? this.signaturePath,
  );

  @override
  List<Object?> get props => [id, status, notes, photos, signaturePath];
}
