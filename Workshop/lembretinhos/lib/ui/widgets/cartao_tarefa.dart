import 'package:flutter/material.dart';

import '../../dominio/tarefa.dart';
import '../tema.dart';

class CartaoTarefa extends StatelessWidget {
  const CartaoTarefa({
    super.key,
    required this.tarefa,
    required this.cor,
    required this.aoTocar,
    required this.aoMarcar,
  });

  final Tarefa tarefa;
  final Color cor;
  final VoidCallback aoTocar;
  final VoidCallback aoMarcar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: Fofo.sombra,
      ),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(tarefa.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarefa.titulo,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Fofo.ameixa,
                        decoration:
                            tarefa.feita ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          tarefa.lembrete == null
                              ? Icons.notifications_none_rounded
                              : Icons.notifications_active_rounded,
                          size: 15,
                          color: tarefa.lembrete == null
                              ? Fofo.ameixaSuave
                              : Fofo.rosa,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tarefa.lembrete ?? 'sem lembrete',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Fofo.ameixaSuave,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: aoMarcar,
                icon: Icon(
                  tarefa.feita ? Icons.favorite : Icons.favorite_border,
                  color: Fofo.rosa,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
