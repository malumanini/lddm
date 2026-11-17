import 'package:flutter/material.dart';

import '../tema.dart';

class FundoFofo extends StatelessWidget {
  const FundoFofo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Fofo.creme, Fofo.rosaClaro],
            ),
          ),
          child: SizedBox.expand(),
        ),
        const _Bolha(top: -60, left: -40, tamanho: 180, cor: Color(0x33E8639B)),
        const _Bolha(top: 120, right: -70, tamanho: 220, cor: Color(0x2BB49BE8)),
        const _Bolha(bottom: -80, left: -50, tamanho: 200, cor: Color(0x2B7FD1BE)),
        const _Enfeite(top: 70, right: 28, icone: Icons.favorite, tamanho: 20),
        const _Enfeite(top: 150, left: 24, icone: Icons.star_rounded, tamanho: 18),
        const _Enfeite(bottom: 140, right: 36, icone: Icons.auto_awesome, tamanho: 22),
        const _Enfeite(bottom: 60, left: 40, icone: Icons.favorite, tamanho: 16),
        child,
      ],
    );
  }
}

class _Bolha extends StatelessWidget {
  const _Bolha({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.tamanho,
    required this.cor,
  });

  final double? top, left, right, bottom;
  final double tamanho;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      ),
    );
  }
}

class _Enfeite extends StatelessWidget {
  const _Enfeite({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.icone,
    required this.tamanho,
  });

  final double? top, left, right, bottom;
  final IconData icone;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Icon(icone, size: tamanho, color: const Color(0x4DE8639B)),
    );
  }
}
