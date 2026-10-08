import 'package:shared_preferences/shared_preferences.dart';

// Preferência (chave e valor), não dado do domínio.
// Exemplo com tema escuro: troque pela configuração que VOCÊ escolher.
class PreferenciasRepositorio {
  static const _chaveTema = 'tema_escuro';

  Future<bool> lerTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    // Na primeira abertura a chave não existe, por isso o ?? false.
    return prefs.getBool(_chaveTema) ?? false;
  }

  Future<void> salvarTemaEscuro(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chaveTema, escuro);
  }
}
