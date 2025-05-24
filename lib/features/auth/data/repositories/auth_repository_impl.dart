import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> signin({
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      final user = await authRemoteDataSource.signin(
        email: email,
        password: password,
      );
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message.toString()));
    } on ServerException catch (e) {
      return left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No internet connection"));
      }
      final user = await authRemoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message.toString()));
    } on ServerException catch (e) {
      return left(Failure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure("No user is logged in"));
        }
        return right(
          UserModel(
            id: session.user.id,
            name: "",
            email: session.user.email ?? "",
          ),
        );
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not logged in"));
      }
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message.toString()));
    } on ServerException catch (e) {
      return left(Failure(e.message.toString()));
    }
  }
}
