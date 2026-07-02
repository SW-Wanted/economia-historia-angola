import 'package:flutter/material.dart';

/// Pulsar contínuo (scale/heartbeat) para criar um ponto focal que atrai a
/// atenção periférica do utilizador e incentiva o toque.
///
/// O ciclo começa quando o widget é montado — ou seja, sempre que se entra na
/// página que o contém (ex.: ao abrir o Explorar) — e repete-se suavemente.
class AttentionPulse extends StatefulWidget {
  const AttentionPulse({super.key, required this.child});

  final Widget child;

  @override
  State<AttentionPulse> createState() => _AttentionPulseState();
}

class _AttentionPulseState extends State<AttentionPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  late final Animation<double> _scale =
      Tween<double>(begin: 1.0, end: 1.12).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

  @override
  void initState() {
    super.initState();
    // Cresce e diminui suavemente, num ciclo contínuo.
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _scale, child: widget.child);
}
