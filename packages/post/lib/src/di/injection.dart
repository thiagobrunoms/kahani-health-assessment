import 'package:common_dependencies/common_dependencies.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'firebase_module.dart';
import 'injection.config.dart';

/// Initializes the dependency injection container for post package
/// This should be called once during app initialization
/// 
/// Example:
/// ```dart
/// configurePostDependencies();
/// ```
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt configurePostDependencies() => init(getIt);

