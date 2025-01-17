import 'package:curhatin/services/auth.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthService>(AuthService());
}