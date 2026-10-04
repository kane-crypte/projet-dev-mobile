import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final Connectivity _connectivity;
  NetworkRepositoryImpl([Connectivity? c])
    : _connectivity = c ?? Connectivity();

  bool _hasNetwork(List<ConnectivityResult> r) =>
      r.any((e) => e != ConnectivityResult.none);

  @override
  Future<bool> get isOnline async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_hasNetwork);
}
