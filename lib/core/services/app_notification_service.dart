import 'dart:convert';
import 'package:farmtec/core/services/notification_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum NotifType { general, weather, market }

class AppNotification {
  final String? titleKey;
  final String? bodyKey;
  final Map<String, String>? bodyParams;
  final String title;
  final String body;
  final String timeKey;
  final Color color;
  final bool isRead;
  final NotifType type;

  AppNotification({
    this.titleKey,
    this.bodyKey,
    this.bodyParams,
    this.title = '',
    this.body = '',
    this.timeKey = 'just_now',
    required this.color,
    this.isRead = false,
    this.type = NotifType.general,
  });
}

class AppNotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  Future<void> fetchDynamicAlerts(NotificationSettingsService settings) async {
    if (settings.marketPriceAlerts) {
      try {
        final res = await http.get(Uri.parse(
            'https://commodities-api.com/api/latest?access_key=DEMO&base=USD&symbols=WHEAT,CORN'));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['data'] != null && data['data']['rates'] != null) {
            final double wheatPrice =
                data['data']['rates']['WHEAT'] ?? 287.50;
            _addNotif(
              titleKey: 'market_update',
              bodyKey: 'notif_market_changed',
              bodyParams: {'price': wheatPrice.toStringAsFixed(2)},
              color: const Color(0xFF4CAF50),
              type: NotifType.market,
            );
          }
        } else {
          _addMockMarket();
        }
      } catch (_) {
        _addMockMarket();
      }
    }

    if (settings.weatherAlerts) {
      _addNotif(
        titleKey: 'weather_alert',
        bodyKey: 'notif_weather_adjust',
        color: const Color(0xFFFF9800),
        type: NotifType.weather,
      );
    }

    notifyListeners();
  }

  void _addMockMarket() {
    _addNotif(
      titleKey: 'market_update',
      bodyKey: 'notif_market_up',
      color: const Color(0xFF4CAF50),
      type: NotifType.market,
    );
  }

  void _addNotif({
    String? titleKey,
    String? bodyKey,
    Map<String, String>? bodyParams,
    required Color color,
    required NotifType type,
  }) {
    if (!_notifications.any((n) => n.titleKey == titleKey && n.type == type)) {
      _notifications.insert(
        0,
        AppNotification(
          titleKey: titleKey,
          bodyKey: bodyKey,
          bodyParams: bodyParams,
          timeKey: 'just_now',
          color: color,
          type: type,
        ),
      );
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
