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

import '../data/authentication_datasource.dart' as _i570;
import '../data/firebase_authentication_datasource.dart' as _i1055;
import '../presentation/navigation/authentication_redirection_handler.dart'
    as _i613;
import '../presentation/navigation/firebase_authentication_redirection_handler.dart'
    as _i712;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.factory<_i570.AuthenticationDatasource>(
    () => _i1055.FirebaseAuthenticationDatasource(),
  );
  gh.factory<_i613.AuthenticationRedirectionHandler>(
    () => _i712.FirebaseAuthenticationRedirectionHandler(
      gh<_i570.AuthenticationDatasource>(),
    ),
  );
  return getIt;
}
