import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/intervention.dart';
import '../blocs/intervention_cubit.dart';
import '../blocs/intervention_state.dart';
import '../blocs/network_cubit.dart';
import '../widgets/network_banner.dart';

class InterventionListPage extends StatelessWidget {
  const InterventionListPage({super.key});

  String _label(InterventionStatus s) {
    switch (s) {
      case InterventionStatus.pending:
        return 'En attente';
      case InterventionStatus.inProgress:
        return 'En cours';
      case InterventionStatus.done:
        return 'Terminée';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes interventions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<InterventionCubit>().load(),
          ),
        ],
      ),
      body: BlocListener<NetworkCubit, bool>(
        // quand le réseau revient, on recharge la liste
        listenWhen: (prev, now) => now == true && prev == false,
        listener: (context, _) => context.read<InterventionCubit>().load(),
        child: Column(
          children: [
            const NetworkBanner(),
            Expanded(
              child: BlocBuilder<InterventionCubit, InterventionState>(
                builder: (context, state) {
                  if (state is InterventionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is InterventionError) {
                    return Center(child: Text('Erreur : ${state.message}'));
                  }
                  if (state is InterventionLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(child: Text('Aucune intervention'));
                    }
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (_, i) {
                        final it = state.items[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${it.priority}'),
                            ),
                            title: Text(it.client),
                            subtitle: Text('${it.description}\n${it.address}'),
                            isThreeLine: true,
                            trailing: Text(_label(it.status)),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
