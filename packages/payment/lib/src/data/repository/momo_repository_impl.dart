import 'package:mvmnt_cli/features/payments/data/datasources/remote/momo_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/momo_repository.dart';

class MomoRepositoryImpl extends MomoRepository {
  final MomoRemoteDatasource remoteDatasouce;

  MomoRepositoryImpl({required this.remoteDatasouce});
}
