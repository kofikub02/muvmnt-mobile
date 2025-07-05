import 'package:dio/dio.dart';
import 'package:mvmnt_cli/core/resources/data_state.dart';
import 'package:mvmnt_cli/features/payments/data/datasources/remote/credits_remote_datasource.dart';
import 'package:mvmnt_cli/features/payments/data/models/payment_credits_model.dart';
import 'package:mvmnt_cli/features/payments/domain/entities/payment_credits_entity.dart';
import 'package:mvmnt_cli/features/payments/domain/repository/payment_credits_repository.dart';

class PaymentCreditsRepositoryImpl implements PaymentCreditsRepository {
  final CreditsRemoteDataSource remoteDataSource;

  PaymentCreditsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<PaymentCreditsEntity>> getCredits() async {
    try {
      final PaymentCreditsModel model = await remoteDataSource.getCredits();
      return DataSuccess(model.toEntity());
    } catch (error) {
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: error.toString(),
        ),
      );
    }
  }
}
