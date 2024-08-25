



import '../entities/message_entity.dart';
import '../repository/chat_repository.dart';

class SeenMessageUpdateUseCase {

  final ChatRepository repository;

  SeenMessageUpdateUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.seenMessageUpdate(message);
  }
}