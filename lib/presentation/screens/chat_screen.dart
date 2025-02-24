import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../domain/entities/chat.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/background_decorator_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _chatId = const Uuid().v4();
  late stt.SpeechToText _speech;
  bool _isRecording = false;
  final bool _isVoiceAvailable = true;
  bool _isSidePanelOpen = true;

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
    context.read<ChatBloc>().add(InitializeChat(chatId: _chatId));
  }

  Future<void> _initializeSpeechToText() async {
    _speech = stt.SpeechToText();
    await _speech.initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSidePanel() {
    setState(() => _isSidePanelOpen = !_isSidePanelOpen);
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

  Future<void> _handleSendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(
        message: message,
        chatId: _chatId,
        isUser: true,
      ));
      
      _messageController.clear();
      _scrollToBottom();
    }
  }

  Future<void> _handleVoiceInput(bool isRecording) async {
    if (!_speech.isAvailable) return;

    if (isRecording) {
      final bool available = await _speech.initialize();
      if (available) {
        setState(() => _isRecording = true);
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isRecording = false);
      _speech.stop();
      if (_messageController.text.isNotEmpty) {
        await _handleSendMessage();
      }
    }
  }

  Future<void> _handleClearChat() async {
    context.read<ChatBloc>().add(ClearChat(chatId: _chatId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final contentWidth = isLargeScreen ? screenWidth * 0.8 : screenWidth * 0.9;

    return BackgroundDecorator(
      child: CustomScaffold(
        currentRoute: RouteManager.chat,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logos/sereni_logo.png'),
          ),
          title: const Text('Chat with Sereni'),
        ),
        body: Row(
          children: [
            if (_isSidePanelOpen)
              Container(
                width: 300,
                margin: const EdgeInsets.all(AppTheme.kSpacing2x),
                decoration: BoxDecoration(
                  color: AppTheme.kPrimaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Chats',
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                                Text(
                                  'Where conversations bloom into insights 🌱',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _toggleSidePanel,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final isSelected = index == 0;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppTheme.kSpacing2x,
                              vertical: AppTheme.kSpacing,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.kPrimaryGreen.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.kRadiusMedium),
                            ),
                            child: ListTile(
                              title: Text(
                                'Chat ${index + 1}',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              subtitle: Text(
                                DateFormat('MMM d, y').format(DateTime.now()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppTheme.kGray600),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: AppTheme.kGray600),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: AppTheme.kGray600),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.kSpacing2x),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.kPrimaryGreen,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Get AI Insights'),
                          ),
                          const SizedBox(height: AppTheme.kSpacing),
                          ElevatedButton(
                            onPressed: _handleClearChat,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.kGray200,
                              foregroundColor: AppTheme.kTextBrown,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text('Clear All Chats'),
                          ),
                          const SizedBox(height: AppTheme.kSpacing2x),
                          Text(
                            '✨ Every chat is a step toward growth',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.kGray600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  if (!_isSidePanelOpen)
                    Positioned(
                      left: AppTheme.kSpacing2x,
                      top: AppTheme.kSpacing2x,
                      child: IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _toggleSidePanel,
                      ),
                    ),
                  Column(
                    children: [
                      _buildWelcomeCard(contentWidth),
                      Expanded(
                        child: _buildChatMessages(contentWidth),
                      ),
                      _buildInputArea(contentWidth),
                    ],
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoaded && state.isProcessing) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.kPrimaryGreen),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(double contentWidth) {
    return Center(
      child: SizedBox(
        width: contentWidth,
        child: Card(
          margin: const EdgeInsets.all(AppTheme.kSpacing2x),
          color: AppTheme.kLightGreenContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.kSpacing2x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to your safe space 🌿',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kPrimaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppTheme.kSpacing),
                Text(
                  'I\'m your personal mental wellness companion. Share your thoughts, feelings, or just chat about your day.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessages(double contentWidth) {
    return Center(
      child: SizedBox(
        width: contentWidth,
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatLoaded && state.messages.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
            }
            if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
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
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildInputArea(double contentWidth) {
    return Center(
      child: Container(
        width: contentWidth,
        padding: const EdgeInsets.all(AppTheme.kSpacing2x),
        decoration: BoxDecoration(
          color: AppTheme.kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppTheme.kGray100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.kSpacing3x,
                      vertical: AppTheme.kSpacing2x,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
              const SizedBox(width: AppTheme.kSpacing),
              if (_isVoiceAvailable) _buildVoiceButton(),
              const SizedBox(width: AppTheme.kSpacing),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onTapDown: (_) => _handleVoiceInput(true),
      onTapUp: (_) => _handleVoiceInput(false),
      onTapCancel: () => _handleVoiceInput(false),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.kSpacing),
        decoration: BoxDecoration(
          color: _isRecording ? AppTheme.kErrorRed : AppTheme.kAccentBrown,
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
        color: AppTheme.kAccentBrown,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.kSpacing),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(false),
          const SizedBox(width: AppTheme.kSpacing),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing2x,
                vertical: AppTheme.kSpacing,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.kAccentBrown : AppTheme.kPrimaryGreen,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppTheme.kRadiusLarge),
                  topRight: const Radius.circular(AppTheme.kRadiusLarge),
                  bottomLeft: Radius.circular(isUser ? AppTheme.kRadiusLarge : 0.0),
                  bottomRight: Radius.circular(isUser ? 0.0 : AppTheme.kRadiusLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.kWhite,
                        ),
                  ),
                  const SizedBox(height: AppTheme.kSpacing / 2),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.kWhite.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppTheme.kSpacing),
          if (isUser) _buildAvatar(true),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppTheme.kGray200,
        child: isUser
            ? const Icon(Icons.person, color: AppTheme.kGray600)
            : Image.asset(
                'assets/logos/sereni_logo.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}