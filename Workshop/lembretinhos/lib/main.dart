import 'dart:async';

import 'package:flutter/material.dart';

import 'dados/notificacoes.dart';
import 'dominio/payload.dart';
import 'ui/tela_lista.dart';
import 'ui/tela_tarefa.dart';
import 'ui/tema.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lancamento = await Notificacoes.instance.init();
  final payloadInicial = lancamento?.didNotificationLaunchApp == true
      ? lancamento!.notificationResponse?.payload
      : null;
  runApp(App(payloadInicial: payloadInicial));
}

class App extends StatefulWidget {
  const App({super.key, this.payloadInicial});

  final String? payloadInicial;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<String?>? _toques;

  @override
  void initState() {
    super.initState();
    _toques = Notificacoes.instance.toques.listen(_abrir);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _abrir(widget.payloadInicial));
  }

  void _abrir(String? payload) {
    final id = parseTarefaId(payload);
    if (id == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => TelaTarefa(id: id)),
    );
  }

  @override
  void dispose() {
    _toques?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Lembretinhos',
      debugShowCheckedModeBanner: false,
      theme: Fofo.tema,
      home: const TelaLista(),
    );
  }
}
