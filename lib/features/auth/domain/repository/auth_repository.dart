import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/common/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signin({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
