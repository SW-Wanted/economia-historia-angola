import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// `FutureBuilder` padronizado para carregar dados do backend.
///
/// Mostra um indicador enquanto carrega e delega a construção ao [builder]
/// quando os dados chegam. O `BackendService` já trata o fallback offline
/// (devolve dados locais em caso de falha), por isso o estado de erro é raro.
class DataLoader<T> extends StatelessWidget {
  const DataLoader({super.key, required this.future, required this.builder});

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Text('Não foi possível carregar os dados.',
                  style: TextStyle(color: AppColors.secondary)),
            ),
          );
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}
