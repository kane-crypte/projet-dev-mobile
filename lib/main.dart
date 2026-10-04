import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/blocs/network_cubit.dart';

import 'injection.dart';
import 'presentation/blocs/intervention_cubit.dart';
import 'presentation/pages/intervention_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const TerrainProApp());
}

class TerrainProApp extends StatelessWidget {
  const TerrainProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerrainPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<InterventionCubit>()..load()),
          BlocProvider.value(value: sl<NetworkCubit>()),
        ],
        child: const InterventionListPage(),
      ),
    );
  }
}
