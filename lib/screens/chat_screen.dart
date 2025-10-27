import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../providers/chat_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/chat_message.dart';
import '../l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final sensorProvider = Provider.of<SensorDataProvider>(context, listen: false);
    
    chatProvider.sendMessage(
      message,
      currentSensorData: sensorProvider.latestSensorData,
    );
    
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.plantAssistant),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                icon: Icon(MdiIcons.deleteOutline),
                onPressed: chatProvider.messages.length > 1
                    ? () => _showClearDialog(context, chatProvider)
                    : null,
                tooltip: AppLocalizations.of(context)!.clearChat,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.chatOutline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.startConversation,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return MessageBubble(
                      message: message,
                      key: ValueKey(message.id),
                    );
                  },
                );
              },
            ),
          ),

          // Error message
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.error != null) {
                return Container(
                  width: double.infinity,
                  color: Colors.red.shade50,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.alertCircleOutline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.chatError,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        icon: Icon(MdiIcons.close, size: 20),
                        onPressed: chatProvider.clearError,
                        color: Colors.red,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.typeMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, child) {
                    return FloatingActionButton(
                      onPressed: chatProvider.isLoading ? null : _sendMessage,
                      mini: true,
                      child: chatProvider.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Icon(MdiIcons.send),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearChat),
        content: Text(AppLocalizations.of(context)!.clearChatConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              chatProvider.clearMessages();
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                MdiIcons.leaf,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: message.isTyping
                  ? _buildTypingIndicator(theme)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isUser)
                          Text(
                            message.content,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        else
                          MarkdownWidget(
                            data: message.content,
                            config: MarkdownConfig(
                              configs: [
                                PConfig(
                                  textStyle: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                                H1Config(
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                H2Config(
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                H3Config(
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CodeConfig(
                                  style: TextStyle(
                                    backgroundColor: theme.colorScheme.surface,
                                    color: theme.colorScheme.onSurface,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                PreConfig(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                BlockquoteConfig(
                                  sideColor: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            shrinkWrap: true,
                            selectable: true,
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: (isUser
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant)
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.secondary,
              child: Icon(
                MdiIcons.account,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Typing...",
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
