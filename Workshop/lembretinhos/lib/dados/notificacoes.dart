import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../dominio/payload.dart';

class Notificacoes {
  Notificacoes._();
  static final instance = Notificacoes._();

  /// No Chrome o plugin não existe, então o app roda só como prévia do layout.
  static bool get suportado => !kIsWeb;

  final _plugin = FlutterLocalNotificationsPlugin();
  final _toques = StreamController<String?>.broadcast();

  Stream<String?> get toques => _toques.stream;

  static const _canal = AndroidNotificationChannel(
    'lembretinhos',
    'Lembretinhos',
    description: 'Lembretes das suas tarefinhas',
    importance: Importance.high,
    playSound: true,
  );

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  NotificationDetails get _detalhes => NotificationDetails(
        android: AndroidNotificationDetails(
          _canal.id,
          _canal.name,
          channelDescription: _canal.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      );

  Future<NotificationAppLaunchDetails?> init() async {
    if (!suportado) return null;

    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    const config = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      config,
      onDidReceiveNotificationResponse: (resposta) =>
          _toques.add(resposta.payload),
    );
    await _android?.createNotificationChannel(_canal);

    return _plugin.getNotificationAppLaunchDetails();
  }

  Future<bool> pedirPermissao() async {
    if (!suportado) return false;

    final android = _android;
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  Future<bool> pedirAlarmesExatos() async {
    if (!suportado) return false;
    return await _android?.requestExactAlarmsPermission() ?? true;
  }

  Future<AndroidScheduleMode> _modo() async {
    final exato = await _android?.canScheduleExactNotifications() ?? true;
    return exato
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  Future<void> lembrarAgora(int tarefaId, String emoji, String titulo) async {
    if (!suportado) return;

    await _plugin.show(
      tarefaId,
      '$emoji Lembretinho',
      titulo,
      _detalhes,
      payload: tarefaPayload(tarefaId),
    );
  }

  Future<DateTime> lembrarDepois(
    int tarefaId,
    String emoji,
    String titulo,
    Duration depois,
  ) async {
    if (!suportado) return DateTime.now().add(depois);

    final quando = tz.TZDateTime.now(tz.local).add(depois);
    await _plugin.zonedSchedule(
      tarefaId,
      '$emoji Lembretinho',
      titulo,
      quando,
      _detalhes,
      androidScheduleMode: await _modo(),
      payload: tarefaPayload(tarefaId),
    );
    return quando;
  }

  Future<DateTime> lembrarTodoDia(
    int tarefaId,
    String emoji,
    String titulo,
    int hora,
    int minuto,
  ) async {
    final agora = DateTime.now();
    var alvo = DateTime(agora.year, agora.month, agora.day, hora, minuto);
    if (alvo.isBefore(agora)) alvo = alvo.add(const Duration(days: 1));
    if (!suportado) return alvo;

    final agoraTz = tz.TZDateTime.now(tz.local);
    var quando = tz.TZDateTime(
        tz.local, agoraTz.year, agoraTz.month, agoraTz.day, hora, minuto);
    if (quando.isBefore(agoraTz)) quando = quando.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      tarefaId + 5000,
      '$emoji Todo dia',
      titulo,
      quando,
      _detalhes,
      androidScheduleMode: await _modo(),
      matchDateTimeComponents: DateTimeComponents.time,
      payload: tarefaPayload(tarefaId),
    );
    return quando;
  }

  Future<void> cancelar(int tarefaId) async {
    if (!suportado) return;
    await _plugin.cancel(tarefaId);
    await _plugin.cancel(tarefaId + 5000);
  }

  Future<void> cancelarTudo() async {
    if (!suportado) return;
    await _plugin.cancelAll();
  }
}
