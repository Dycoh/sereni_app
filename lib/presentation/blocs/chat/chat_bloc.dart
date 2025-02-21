// chat_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/chat.dart';
import '../../../data/repositories/chat_repository.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class InitializeChat extends ChatEvent {
  final String chatId;
  
  const InitializeChat({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String message;
  final String chatId;
  
  const SendMessage({
    required this.message,
    required this.chatId,
  });

  @override
  List<Object> get props => [message, chatId];
}

class ReceiveMessage extends ChatEvent {
  final ChatMessage message;
  final String chatId;
  
  const ReceiveMessage({
    required this.message,
    required this.chatId,
  });

  @override
  List<Object> get props => [message, chatId];
}

class ClearChat extends ChatEvent {
  final String chatId;
  
  const ClearChat({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

// States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isProcessing;

  const ChatLoaded({
    required this.messages,
    this.isProcessing = false,
  });

  @override
  List<Object> get props => [messages, isProcessing];

  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isProcessing,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final _uuid = const Uuid();

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final messages = await _chatRepository.getChatHistory(event.chatId);
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(message: 'Failed to initialize chat: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state is ChatLoaded) {
        final currentState = state as ChatLoaded;
        
        // Create user message
        final userMessage = ChatMessage(
          id: _uuid.v4(),
          content: event.message,
          timestamp: DateTime.now(),
          isUser: true,
        );

        // Update state with new message and processing indicator
        emit(currentState.copyWith(
          messages: [...currentState.messages, userMessage],
          isProcessing: true,
        ));

        // Save message
        await _chatRepository.addMessage(event.chatId, userMessage);

        // Generate AI response
        try {
          final aiResponse = await _chatRepository.generateAIResponse(event.message);
          final aiMessage = ChatMessage(
            id: _uuid.v4(),
            content: aiResponse,
            timestamp: DateTime.now(),
            isUser: false,
          );
          add(ReceiveMessage(message: aiMessage, chatId: event.chatId));
        } catch (e) {
          emit(ChatError(message: 'Failed to generate AI response: ${e.toString()}'));
        }
      }
    } catch (e) {
      emit(ChatError(message: 'Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state is ChatLoaded) {
        final currentState = state as ChatLoaded;
        
        // Save AI message
        await _chatRepository.addMessage(event.chatId, event.message);

        // Update state with new message and remove processing indicator
        emit(currentState.copyWith(
          messages: [...currentState.messages, event.message],
          isProcessing: false,
        ));
      }
    } catch (e) {
      emit(ChatError(message: 'Failed to receive message: ${e.toString()}'));
    }
  }

  Future<void> _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      await _chatRepository.clearChat(event.chatId);
      emit(const ChatLoaded(messages: []));
    } catch (e) {
      emit(ChatError(message: 'Failed to clear chat: ${e.toString()}'));
    }
  }
}