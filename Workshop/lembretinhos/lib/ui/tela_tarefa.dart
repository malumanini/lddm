import 'package:flutter/material.dart';

import '../dados/notificacoes.dart';
import '../dados/tarefa_repositorio.dart';
import '../dominio/payload.dart';
import 'tema.dart';
import 'widgets/fundo_fofo.dart';

class TelaTarefa extends StatelessWidget {
  const TelaTarefa({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final servico = Notificacoes.instance;

    return Scaffold(
      body: FundoFofo(
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: TarefaRepositorio.instance,
            builder: (context, _, __) {
              final tarefa = TarefaRepositorio.instance.byId(id);
              if (tarefa == null) {
                return const Center(
                  child: Text('Tarefinha não encontrada',
                      style: TextStyle(color: Fofo.ameixa)),
                );
              }

              void aviso(String texto) {
                if (!context.mounted) return;
                final completo = Notificacoes.suportado
                    ? texto
                    : '$texto (no navegador é só prévia)';
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(completo)));
              }

              String hora(DateTime d) =>
                  TimeOfDay.fromDateTime(d).format(context);

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Fofo.ameixa),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 104,
                      height: 104,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: Fofo.sombra,
                      ),
                      child: Text(tarefa.emoji,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(tarefa.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Fofo.ameixa,
                      )),
                  const SizedBox(height: 8),
                  Text(tarefa.lembrete ?? 'nenhum lembrete por aqui',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, color: Fofo.ameixaSuave)),
                  const SizedBox(height: 28),
                  _Botao(
                    emoji: '🔔',
                    texto: 'Lembrar agora',
                    aoTocar: () async {
                      await servico.lembrarAgora(
                          tarefa.id, tarefa.emoji, tarefa.titulo);
                      TarefaRepositorio.instance
                          .definirLembrete(tarefa.id, 'avisado agora');
                      aviso('Lembretinho enviado 🎀');
                    },
                  ),
                  _Botao(
                    emoji: '⏰',
                    texto: 'Lembrar em 1 minuto',
                    aoTocar: () async {
                      final quando = await servico.lembrarDepois(
                          tarefa.id,
                          tarefa.emoji,
                          tarefa.titulo,
                          const Duration(minutes: 1));
                      TarefaRepositorio.instance
                          .definirLembrete(tarefa.id, 'às ${hora(quando)}');
                      aviso('Agendado para ${hora(quando)}');
                    },
                  ),
                  _Botao(
                    emoji: '🌞',
                    texto: 'Lembrar todo dia às 08:00',
                    aoTocar: () async {
                      final quando = await servico.lembrarTodoDia(
                          tarefa.id, tarefa.emoji, tarefa.titulo, 8, 0);
                      TarefaRepositorio.instance
                          .definirLembrete(tarefa.id, 'todo dia às 08:00');
                      aviso('Primeiro aviso: ${hora(quando)}');
                    },
                  ),
                  _Botao(
                    emoji: '🧪',
                    texto: 'Em 10 s (feche o app)',
                    aoTocar: () async {
                      await servico.lembrarDepois(tarefa.id, tarefa.emoji,
                          tarefa.titulo, const Duration(seconds: 10));
                      TarefaRepositorio.instance
                          .definirLembrete(tarefa.id, 'chegando em 10 s');
                      aviso('Feche o app e espere 🎀');
                    },
                  ),
                  _Botao(
                    emoji: '🧹',
                    texto: 'Cancelar lembrete',
                    aoTocar: () async {
                      await servico.cancelar(tarefa.id);
                      TarefaRepositorio.instance
                          .definirLembrete(tarefa.id, null);
                      aviso('Lembrete cancelado');
                    },
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text('payload: ${tarefaPayload(tarefa.id)}',
                        style: const TextStyle(
                            fontSize: 13, color: Fofo.ameixaSuave)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Botao extends StatelessWidget {
  const _Botao({
    required this.emoji,
    required this.texto,
    required this.aoTocar,
  });

  final String emoji;
  final String texto;
  final Future<void> Function() aoTocar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: Fofo.sombra,
        ),
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(texto,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Fofo.ameixa,
                      )),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Fofo.ameixaSuave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
