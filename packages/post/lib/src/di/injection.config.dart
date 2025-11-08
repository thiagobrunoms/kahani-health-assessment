// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/datasources/firebase_posts_datasource.dart' as _i757;
import '../data/datasources/posts_datasource.dart' as _i620;
import '../data/repositories/firebase_posts_repository.dart' as _i311;
import '../domain/repository/posts_repository.dart' as _i267;
import 'firebase_module.dart' as _i616;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final firebaseModule = _$FirebaseModule();
  gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
  gh.factory<_i620.PostsDataSource>(
    () =>
        _i757.FirebasePostsDataSource(firestore: gh<_i974.FirebaseFirestore>()),
  );
  gh.factory<_i267.PostsRepository>(
    () => _i311.FirebasePostsRepository(gh<_i620.PostsDataSource>()),
  );
  return getIt;
}

class _$FirebaseModule extends _i616.FirebaseModule {}
