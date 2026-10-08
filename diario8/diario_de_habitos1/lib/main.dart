import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diario_de_habitos1/dominio/habitos_store.dart';
import 'package:diario_de_habitos1/dominio/tema_store.dart';
import 'package:diario_de_habitos1/dados/habitos_repositorio.dart';
import 'package:diario_de_habitos1/dados/preferencias_repositorio.dart';

import 'ui/tela_habitos.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      // ..carregar() lê do banco já na abertura
      ChangeNotifierProvider(
        create: (_) => HabitosStore(HabitosRepositorio())..carregar(),
      ),
      // ..carregar() lê a preferência já na abertura
      ChangeNotifierProvider(
        create: (_) => TemaStore(PreferenciasRepositorio())..carregar(),
      ),
    ],
    child: const DiarioApp(),
  ),
);

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const semente = Color(0xFF1A5276);

    return MaterialApp(
      title: 'Diário de Hábitos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: semente),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: semente,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: context.watch<TemaStore>().escuro
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const TelaHabitos(),
    );
  }
}
