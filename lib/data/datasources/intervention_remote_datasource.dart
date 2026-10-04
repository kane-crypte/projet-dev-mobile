import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/intervention_model.dart';

class InterventionRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  InterventionRemoteDataSource({
    http.Client? client,
    this.baseUrl = 'http://10.0.2.2:3000', // émulateur Android
  }) : client = client ?? http.Client();

  Future<List<InterventionModel>> fetchAll() async {
    final res = await client
        .get(Uri.parse('$baseUrl/interventions'))
        .timeout(const Duration(seconds: 5));
    if (res.statusCode != 200) {
      throw Exception('Erreur API: ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => InterventionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> update(InterventionModel m) async {
    final res = await client
        .put(
          Uri.parse('$baseUrl/interventions/${m.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(m.toJson()),
        )
        .timeout(const Duration(seconds: 5));
    if (res.statusCode != 200) {
      throw Exception('Erreur API: ${res.statusCode}');
    }
  }
}
