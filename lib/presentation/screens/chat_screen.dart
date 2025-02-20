// lib/presentation/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../app/theme/theme.dart';
import '../../domain/entities/chat.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const InitializeChat());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(message: message));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildWelcomeCard(),
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.kPrimaryGreen,
              child: Icon(
                Icons.psychology,
                color: AppTheme.kWhite,
              ),
            ),
            const SizedBox(width: AppTheme.kSpacing2x),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sereni AI',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Your Mental Health Companion',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      margin: const EdgeInsets.all(AppTheme.kSpacing2x),
      color: AppTheme.kLightGreenContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.kSpacing2x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Sereni AI',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.kPrimaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.kSpacing),
            Text(
              'I\'m here to listen, support, and guide you. Feel free to share your thoughts or ask questions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded && state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatLoaded) {
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.kSpacing2x,
              vertical: AppTheme.kSpacing,
            ),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              return _ChatBubble(
                message: message,
                isUser: message.isUser,
              );
            },
          );
        }

        if (state is ChatError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppTheme.kErrorRed),
            ),
          );
        }

        return const Center(
          child: Text('Start a conversation'),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
      decoration: BoxDecoration(
        color: AppTheme.kWhite,
        boxShadow: AppTheme.kShadowSmall,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.kGray100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.kSpacing2x,
                    vertical: AppTheme.kSpacing,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _handleSendMessage(),
              ),
            ),
            const SizedBox(width: AppTheme.kSpacing),
            _buildVoiceButton(),
            const SizedBox(width: AppTheme.kSpacing),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isRecording = true),
      onTapUp: (_) => setState(() => _isRecording = false),
      onTapCancel: () => setState(() => _isRecording = false),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.kSpacing),
        decoration: BoxDecoration(
          color: _isRecording ? AppTheme.kErrorRed : AppTheme.kPrimaryGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isRecording ? Icons.mic : Icons.mic_none,
          color: AppTheme.kWhite,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.kPrimaryGreen,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.send),
        color: AppTheme.kWhite,
        onPressed: _handleSendMessage,
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const _ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 50.0 : 0.0,
          right: isUser ? 0.0 : 50.0,
          top: AppTheme.kSpacing,
          bottom: AppTheme.kSpacing,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.kSpacing2x,
          vertical: AppTheme.kSpacing,
        ),
        decoration: BoxDecoration(
          color: isUser 
            ? AppTheme.kPrimaryGreen
            : AppTheme.kLightBrownContainer,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppTheme.kRadiusLarge),
            topRight: const Radius.circular(AppTheme.kRadiusLarge),
            bottomLeft: Radius.circular(isUser ? AppTheme.kRadiusLarge : 0.0),
            bottomRight: Radius.circular(isUser ? 0.0 : AppTheme.kRadiusLarge),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser ? AppTheme.kWhite : AppTheme.kTextBrown,
              ),
            ),
            const SizedBox(height: AppTheme.kSpacing / 2),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUser 
                  ? AppTheme.kWhite.withOpacity(0.7)
                  : AppTheme.kTextBrown.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}