import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await Directory('docs/screenshots').create(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      await File('docs/screenshots/$name.png').writeAsBytes(bytes);
      return true;
    },
    responseDataCallback: (data) async {
      await File('docs/screenshots/device-test-result.txt').writeAsString(
        'All device tests passed. Screenshots captured for all AppScreen values in light and dark mode.',
      );
    },
  );
}
