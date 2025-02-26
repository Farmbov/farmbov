import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  /// Configura a instância de Push Notifications do OneSignal.
  static void setUp() async {
    if (kIsWeb) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    // TODO: make env variable
    OneSignal.shared.setAppId("e00a0f55-6d54-4e13-9531-fad1bc710fab");

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  static void setUser(String email, String userId, {String? number}) async {
    if (kIsWeb) return;

    OneSignal.shared.setEmail(email: email);
    OneSignal.shared.setExternalUserId(userId);

    if (number?.isEmpty ?? true) return;

    OneSignal.shared.setSMSNumber(smsNumber: number!);
  }
}
