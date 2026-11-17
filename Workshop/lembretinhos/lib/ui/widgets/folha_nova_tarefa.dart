import 'package:flutter/material.dart';

import '../../dados/tarefa_repositorio.dart';
import '../tema.dart';

Future<void> abrirNovaTarefa(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => const _FolhaNovaTarefa(),
  );
}

class _FolhaNovaTarefa extends StatefulWidget {
  const _FolhaNovaTarefa();

  @override
  State<_FolhaNovaTarefa> createState() => _FolhaNovaTarefaState();
}

class _FolhaNovaTarefaState extends State<_FolhaNovaTarefa> {
  static const _emojis = ['🌸', '🧋', '📚', '🎀', '🐰', '☁️', '🍓', '✨'];

  final _controle = TextEditingController();
  String _emoji = _emojis.first;

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _salvar() {
    final titulo = _controle.text.trim();
    if (titulo.isEmpty) return;
    TarefaRepositorio.instance.add(_emoji, titulo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Fofo.rosaClaro,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Nova tarefinha',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Fofo.ameixa)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            children: [
              for (final e in _emojis)
                GestureDetector(
                  onTap: () => setState(() => _emoji = e),
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _emoji == e ? Fofo.rosaClaro : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _emoji == e ? Fofo.rosa : const Color(0x22000000),
                        width: _emoji == e ? 2 : 1,
                      ),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 22)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _controle,
            autofocus: true,
            onSubmitted: (_) => _salvar(),
            style: const TextStyle(fontSize: 16, color: Fofo.ameixa),
            decoration: InputDecoration(
              hintText: 'o que você quer lembrar?',
              filled: true,
              fillColor: Fofo.creme,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _salvar,
              style: FilledButton.styleFrom(
                backgroundColor: Fofo.rosa,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Adicionar 🎀',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
