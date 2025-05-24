import 'package:fpdart/fpdart.dart';
import 'package:blog_app/core/error/failures.dart';

class NoParams {}

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
