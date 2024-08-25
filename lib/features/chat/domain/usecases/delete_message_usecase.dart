



import '../entities/message_entity.dart';
import '../repository/chat_repository.dart';

class DeleteMessageUseCase {

  final ChatRepository repository;

  DeleteMessageUseCase({required this.repository});

  Future<void> call(MessageEntity message) async {
    return await repository.deleteMessage(message);
  }
}