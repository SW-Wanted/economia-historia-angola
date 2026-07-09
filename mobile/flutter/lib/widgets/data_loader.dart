import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'app_loading_indicator.dart';

/// `FutureBuilder` padronizado para carregar dados do backend.
///
/// Mostra um indicador enquanto carrega e delega a construção ao [builder]
/// quando os dados chegam. O `BackendService` já trata o fallback offline
/// (devolve dados locais em caso de falha), por isso o estado de erro é raro.
class DataLoader<T> extends StatelessWidget {
  const DataLoader({super.key, required this.future, required this.builder, this.emptyMessage});

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;

  /// Mensagem a mostrar quando o backend responde com uma coleção vazia.
  /// Se `null`, delega ao [builder] (que pode simplesmente não renderizar nada).
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: AppLoadingIndicator(message: 'A preparar conteúdos...')),
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
        final data = snapshot.data as T;
        if (emptyMessage != null && data is Iterable && data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(emptyMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.secondary)),
            ),
          );
        }
        return builder(context, data);
      },
    );
  }
}
