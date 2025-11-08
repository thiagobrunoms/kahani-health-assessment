// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../navigation/app_navigator.dart' as _i397;
import '../router/app_go_router.dart' as _i550;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.singleton<_i550.AppGoRouter>(() => _i550.AppGoRouter());
  gh.factory<_i397.AppNavigator>(
    () => _i397.AppNavigator(gh<_i550.AppGoRouter>()),
  );
  return getIt;
}
