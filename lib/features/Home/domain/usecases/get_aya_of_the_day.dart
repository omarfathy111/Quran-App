import 'package:noor_aliman/features/Home/data/models/aya_model.dart';
import 'package:noor_aliman/features/Home/data/repositories/aya_remote_data_source.dart';


class GetAyaOfTheDay {
  final AyaRemoteDataSource remoteDataSource;

  GetAyaOfTheDay({required this.remoteDataSource});

  Future<AyaModel> call() async {
    return await remoteDataSource.getAyaOfTheDay();
  }
}