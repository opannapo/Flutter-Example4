import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class SplashBloc {
  void dispose() {}

  Future<void> doFirebaseConfig() async {
    final FirebaseApp app = await FirebaseApp.configure(
        name: 'demogeo',
        options: Platform.isIOS
            ? const FirebaseOptions(
                googleAppID: '1:xxxxx',
                gcmSenderID: 'xxxxx',
                apiKey: 'xxxxx',
                projectID: 'xxxxx')
            : const FirebaseOptions(
                googleAppID: '1:xxxxx',
                gcmSenderID: 'xxxxx',
                apiKey: 'xxxxx',
                projectID: 'xxxxx'));
  }
}
