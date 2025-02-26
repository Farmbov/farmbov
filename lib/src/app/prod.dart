import 'package:farmbov/app.dart';
import 'package:farmbov/src/app/environments/production_environment.dart';

Future<void> main() async => mainApp(environment: ProductionEnvironment());
