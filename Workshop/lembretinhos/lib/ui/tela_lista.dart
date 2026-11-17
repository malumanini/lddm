import 'package:flutter/material.dart';

import '../dados/notificacoes.dart';
import '../dados/tarefa_repositorio.dart';
import 'tela_tarefa.dart';
import 'tema.dart';
import 'widgets/cartao_tarefa.dart';
import 'widgets/folha_nova_tarefa.dart';
import 'widgets/fundo_fofo.dart';

class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  bool _permitido = false;

  Future<void> _pedirPermissao() async {
    final ok = await Notificacoes.instance.pedirPermissao();
    if (ok) await Notificacoes.instance.pedirAlarmesExatos();
    if (!mounted) return;
    setState(() => _permitido = ok);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'Lembretes ativados 🎀'
            : 'Sem permissão, nenhum lembrete vai aparecer'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FundoFofo(
        child: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: TarefaRepositorio.instance,
            builder: (context, tarefas, _) {
              final feitas = tarefas.where((t) => t.feita).length;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  const Text('Lembretinhos 🎀',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Fofo.ameixa,
                        letterSpacing: -0.5,
                      )),
                  const SizedBox(height: 4),
                  Text('$feitas de ${tarefas.length} tarefinhas prontinhas',
                      style: const TextStyle(
                          fontSize: 15, color: Fofo.ameixaSuave)),
                  const SizedBox(height: 20),
                  _CartaoAviso(
                      permitido: _permitido, aoPedir: _pedirPermissao),
                  const SizedBox(height: 22),
                  const Text('Hoje',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Fofo.ameixa)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < tarefas.length; i++)
                    CartaoTarefa(
                      tarefa: tarefas[i],
                      cor: Fofo.pastel[i % Fofo.pastel.length],
                      aoTocar: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TelaTarefa(id: tarefas[i].id),
                        ),
                      ),
                      aoMarcar: () => TarefaRepositorio.instance
                          .alternarFeita(tarefas[i].id),
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: () async {
                        await Notificacoes.instance.cancelarTudo();
                        for (final t in TarefaRepositorio.instance.value) {
                          TarefaRepositorio.instance
                              .definirLembrete(t.id, null);
                        }
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Todos os lembretes cancelados')),
                        );
                      },
                      icon: const Icon(Icons.cleaning_services_rounded,
                          size: 18, color: Fofo.ameixaSuave),
                      label: const Text('cancelar todos os lembretes',
                          style: TextStyle(color: Fofo.ameixaSuave)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirNovaTarefa(context),
        backgroundColor: Fofo.rosa,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('tarefinha',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CartaoAviso extends StatelessWidget {
  const _CartaoAviso({required this.permitido, required this.aoPedir});

  final bool permitido;
  final VoidCallback aoPedir;

  @override
  Widget build(BuildContext context) {
    if (!Notificacoes.suportado) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: Fofo.sombra,
        ),
        child: Row(
          children: const [
            Text('🌐', style: TextStyle(fontSize: 26)),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'No navegador isto é só a prévia do layout. '
                'Os lembretes funcionam no Android.',
                style: TextStyle(
                    fontSize: 14, color: Fofo.ameixa, height: 1.3),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: permitido ? const Color(0xFFDFF3EE) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: Fofo.sombra,
      ),
      child: Row(
        children: [
          Text(permitido ? '✅' : '🔔', style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              permitido
                  ? 'Tudo certo! Seus lembretes estão ativados.'
                  : 'Ative os lembretes para o app poder te avisar.',
              style:
                  const TextStyle(fontSize: 14, color: Fofo.ameixa, height: 1.3),
            ),
          ),
          if (!permitido)
            FilledButton(
              onPressed: aoPedir,
              style: FilledButton.styleFrom(
                backgroundColor: Fofo.rosa,
                shape: const StadiumBorder(),
              ),
              child: const Text('ativar'),
            ),
        ],
      ),
    );
  }
}
