import 'package:get_it/get_it.dart';

import 'data/repositories/network_repository_impl.dart';
import 'domain/repositories/network_repository.dart';
import 'domain/usecases/sync_pending.dart';
import 'presentation/blocs/network_cubit.dart';

import 'data/datasources/intervention_local_datasource.dart';
import 'data/datasources/intervention_remote_datasource.dart';
import 'data/repositories/intervention_repository_impl.dart';
import 'domain/repositories/intervention_repository.dart';
import 'domain/usecases/get_interventions.dart';
import 'presentation/blocs/intervention_cubit.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Data
  sl.registerLazySingleton(() => InterventionRemoteDataSource());
  sl.registerLazySingleton(() => InterventionLocalDataSource());
  sl.registerLazySingleton<InterventionRepository>(
    () => InterventionRepositoryImpl(
      remote: sl<InterventionRemoteDataSource>(),
      local: sl<InterventionLocalDataSource>(),
    ),
  );

  // Domain
  sl.registerLazySingleton(
    () => GetInterventions(sl<InterventionRepository>()),
  );

  // Presentation
  sl.registerFactory(() => InterventionCubit(sl<GetInterventions>()));

  sl.registerLazySingleton<NetworkRepository>(() => NetworkRepositoryImpl());
  sl.registerLazySingleton(() => SyncPending(sl<InterventionRepository>()));
  sl.registerLazySingleton(
    () => NetworkCubit(sl<NetworkRepository>(), sl<SyncPending>()),
  );
}
