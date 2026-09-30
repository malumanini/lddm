import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diario_de_habitos1/dominio/habitos_store.dart';
import 'package:diario_de_habitos1/dados/habitos_repositorio.dart';
import 'ui/tela_habitos.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => HabitosStore(HabitosRepositorio()),
    child: const DiarioApp(),
  ),
);

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Diário de Hábitos',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A5276)),
      useMaterial3: true,
    ),
    home: const TelaHabitos(),
  );
}