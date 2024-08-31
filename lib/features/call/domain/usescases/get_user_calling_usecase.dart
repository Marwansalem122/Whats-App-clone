


import '../entities/call_entity.dart';
import '../repository/call_repository.dart';


class GetUserCallingUseCase {

  final CallRepository repository;

  const GetUserCallingUseCase({required this.repository});

  Stream<List<CallEntity>> call(String uid)  {
    return repository.getUserCalling(uid);
  }
}