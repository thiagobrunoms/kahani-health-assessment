import 'package:common_dependencies/common_dependencies.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

/// Initializes the dependency injection container for authentication package
/// This should be called once during app initialization
/// 
/// Example:
/// ```dart
/// configureAuthenticationDependencies();
/// ```
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt configureAuthenticationDependencies() => init(getIt);

