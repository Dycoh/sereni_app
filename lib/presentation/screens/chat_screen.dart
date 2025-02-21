import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../app/routes.dart';
import '../../app/theme/theme.dart';
import '../../domain/entities/chat.dart';
import '../../presentation/blocs/chat/chat_bloc.dart';
import '../widgets/navigation_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  bool _isVoiceAvailable = true;
  bool _isSidePanelOpen = true;

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

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(message: message));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _handleVoiceInput(bool isRecording) {
    setState(() => _isRecording = isRecording);
    if (!isRecording) {
      // TODO: Implement voice-to-text conversion
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final contentWidth = isLargeScreen ? screenWidth * 0.8 : screenWidth * 0.9;

    return CustomScaffold(
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
                color: AppTheme.kPrimaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.kRadiusLarge),
                boxShadow: AppTheme.kShadowSmall,
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
                                ? AppTheme.kPrimaryGreen.withOpacity(0.1)
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
                          onPressed: () {},
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Rest of the widget methods remain the same...
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
          },
          builder: (context, state) {
            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.kSpacing2x,
                vertical: AppTheme.kSpacing,
              ),
              children: [
                _ChatBubble(
                  message: ChatMessage(
                    id: 'placeholder-1',
                    content: "Hi there! How are you feeling today?",
                    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
                    isUser: false,
                  ),
                  isUser: false,
                ),
                _ChatBubble(
                  message: ChatMessage(
                    id: 'placeholder-2',
                    content: "I'm feeling a bit anxious about my upcoming presentation...",
                    timestamp: DateTime.now(),
                    isUser: true,
                  ),
                  isUser: true,
                ),
                if (state is ChatLoaded)
                  ...state.messages.map((message) => _ChatBubble(
                        message: message,
                        isUser: message.isUser,
                      )),
              ],
            );
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
          boxShadow: AppTheme.kShadowSmall,
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
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppTheme.kGray200,
      child: isUser
          ? const Icon(Icons.person)
          : Image.asset('assets/logos/sereni_logo.png', width: 24),
    );
  }
}