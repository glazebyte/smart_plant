// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  content: json['content'] as String,
  role: $enumDecode(_$MessageRoleEnumMap, json['role']),
  timestamp: DateTime.parse(json['timestamp'] as String),
  isTyping: json['isTyping'] as bool? ?? false,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'isTyping': instance.isTyping,
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
};
