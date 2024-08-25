


import '../entities/chat_entity.dart';
import '../repository/chat_repository.dart';

class DeleteMyChatUseCase {

  final ChatRepository repository;

  DeleteMyChatUseCase({required this.repository});

  Future<void> call(ChatEntity chat) async {
    return await repository.deleteChat(chat);
  }
}