import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/network_repository.dart';
import '../../domain/usecases/sync_pending.dart';

/// État : true = en ligne, false = hors ligne
class NetworkCubit extends Cubit<bool> {
  final NetworkRepository network;
  final SyncPending syncPending;
  StreamSubscription<bool>? _sub;

  NetworkCubit(this.network, this.syncPending) : super(true) {
    _init();
  }

  Future<void> _init() async {
    final online = await network.isOnline;
    if (online) await _safeSync();
    if (!isClosed) emit(online);

    _sub = network.onStatusChange.listen((online) async {
      if (online) await _safeSync(); // envoi de la file d'attente
      if (!isClosed) emit(online);
    });
  }

  Future<void> _safeSync() async {
    try {
      await syncPending();
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
