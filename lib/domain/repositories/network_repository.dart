abstract class NetworkRepository {
  Future<bool> get isOnline;
  Stream<bool> get onStatusChange;
}
