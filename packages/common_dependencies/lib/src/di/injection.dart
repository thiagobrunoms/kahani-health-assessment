import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Initializes the dependency injection container
/// This should be called once during app initialization
/// 
/// Example:
/// ```dart
/// configureDependencies();
/// ```
@InjectableInit()
GetIt configureDependencies() => getIt.init();

