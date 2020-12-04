import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  // we added api key to environment by running 'flutter run --dart-define=movieApiKey=MYKEY'
  final movieApiKey = const String.fromEnvironment('movieApiKey');
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
