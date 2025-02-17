// presentation/blocs/chat/chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/chat_repository.dart';

// Events
abstract class ChatEvent {}
class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}
class LoadChat extends ChatEvent {}

// States
abstract class ChatState {}
class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;
  ChatLoaded(this.messages);
}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<LoadChat>(_onLoadChat);
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    // Implementation
  }

  Future<void> _onLoadChat(LoadChat event, Emitter<ChatState> emit) async {
    // Implementation
  }
}