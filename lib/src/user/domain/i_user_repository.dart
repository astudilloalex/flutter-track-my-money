import 'package:fpdart/fpdart.dart';
import 'package:track_my_money/app/error/failure.dart';
import 'package:track_my_money/src/user/domain/user.dart';

abstract class IUserRepository {
  const IUserRepository();

  Future<Either<Failure, User>> findByCode(String code);
  Future<Either<Failure, User>> save(User user);
  Future<Either<Failure, User>> saveOrUpdate(User user);
  Future<Either<Failure, User>> update(User user);
}
