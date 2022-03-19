import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig{
  final movieApiKey = const String.fromEnvironment("movieApiKey", defaultValue: "b5b58578575568a3e82bdd533270acdd");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref)=> EnvironmentConfig());