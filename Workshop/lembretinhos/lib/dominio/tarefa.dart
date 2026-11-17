class Tarefa {
  Tarefa({
    required this.id,
    required this.emoji,
    required this.titulo,
    this.feita = false,
    this.lembrete,
  });

  final int id;
  final String emoji;
  final String titulo;
  bool feita;
  String? lembrete;
}
