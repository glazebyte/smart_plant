import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';
import '../models/sensor_data.dart';
import '../config/chat_config.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatProvider() {
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Hello! I'm your Smart Plant Assistant. I can help you with plant care advice, interpret your sensor data, and answer questions about your plant's health. How can I help you today?",
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );
    _messages.add(welcomeMessage);
  }

  Future<void> sendMessage(String content, {SensorData? currentSensorData}) async {
    if (content.trim().isEmpty) return;

    _error = null;
    notifyListeners();

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);

    // Add typing indicator
    final typingMessage = ChatMessage(
      id: 'typing',
      content: '',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      isTyping: true,
    );
    _messages.add(typingMessage);
    notifyListeners();

    try {
      _isLoading = true;
      
      // Prepare context with sensor data if available
      String systemContext = _buildSystemContext(currentSensorData);
      
      // Prepare messages for OpenRouter API
      List<Map<String, dynamic>> apiMessages = [
        {
          "role": "system",
          "content": systemContext,
        },
      ];

      // Add recent conversation history (last configured number of messages)
      final recentMessages = _messages
          .where((msg) => !msg.isTyping && msg.role != MessageRole.system)
          .toList();
      
      // Take only the last configured number of messages
      final messagesToInclude = recentMessages.length > ChatConfig.maxConversationHistory
          ? recentMessages.sublist(recentMessages.length - ChatConfig.maxConversationHistory)
          : recentMessages;

      for (final message in messagesToInclude) {
        if (message.id != userMessage.id) { // Don't include the current message twice
          apiMessages.add({
            "role": message.role == MessageRole.user ? "user" : "assistant",
            "content": message.content,
          });
        }
      }

      // Add current user message
      apiMessages.add({
        "role": "user",
        "content": content,
      });

      // Make request to OpenRouter
      final response = await _makeOpenRouterRequest(apiMessages);

      // Remove typing indicator
      _messages.removeWhere((msg) => msg.isTyping);

      // Add AI response
      final assistantMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      _messages.add(assistantMessage);

    } catch (e) {
      // Remove typing indicator
      _messages.removeWhere((msg) => msg.isTyping);
      
      _error = e.toString();
      
      // Add error message for better UX
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: "I'm sorry, I encountered an error. Please check your OpenRouter API key configuration and try again. Error: ${e.toString()}",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _makeOpenRouterRequest(List<Map<String, dynamic>> messages) async {
    final url = Uri.parse('${ChatConfig.baseUrl}/chat/completions');
    
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ChatConfig.openRouterApiKey}',
      'HTTP-Referer': ChatConfig.appUrl,
      'X-Title': ChatConfig.appName,
    };

    final body = {
      'model': ChatConfig.defaultModel,
      'messages': messages,
      'max_tokens': ChatConfig.maxTokens,
      'temperature': ChatConfig.temperature,
      'stream': false,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['choices'] != null && 
            responseData['choices'].isNotEmpty &&
            responseData['choices'][0]['message'] != null &&
            responseData['choices'][0]['message']['content'] != null) {
          
          return responseData['choices'][0]['message']['content'].toString().trim();
        } else {
          throw Exception('Invalid response format from OpenRouter API');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        throw Exception('OpenRouter API error (${response.statusCode}): $errorMessage');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Failed to parse OpenRouter API response');
      }
      rethrow;
    }
  }

  String _buildSystemContext(SensorData? sensorData) {
    String baseContext = """
You are a Smart Plant Assistant, an AI expert in plant care and monitoring. You help users understand their plant's health and provide actionable advice.

Your expertise includes:
- Plant care and watering schedules
- Interpreting sensor data (soil moisture, humidity, temperature)
- Identifying plant health issues
- Providing specific recommendations based on sensor readings
- General gardening and plant care advice

Guidelines:
- Be friendly, helpful, and encouraging
- Provide specific, actionable advice
- Always consider the plant's current sensor data when giving recommendations
- If sensor data shows concerning values, prioritize addressing those issues
- Keep responses concise but informative
- Use encouraging language to help users feel confident about plant care

Response Formatting:
- Use **markdown formatting** to make your responses more readable
- Use **bold text** for important points and recommendations
- Use bullet points (-) for lists and steps
- Use `code formatting` for specific values or measurements
- Use > blockquotes for important tips or warnings
- Use headers (##) to organize longer responses
- Structure your responses with clear sections when helpful

Example formatting:
## Assessment
Your plant's current status...

## Recommendations
- **Immediate action**: Do this first
- **Monitor**: Keep an eye on this
- **Long-term**: Consider this for future

> **Tip**: Remember that consistency is key in plant care!
""";

    if (sensorData != null) {
      baseContext += """

Current Sensor Data:
- Soil Moisture: ${sensorData.soilMoisturePercentage}%
- Humidity: ${sensorData.humidityPercentage}%
- Temperature: ${sensorData.temperatureCelsius}°C
- Reading Time: ${sensorData.dateTime.toString()}
- Soil Moisture Level: ${sensorData.soilMoistureLevel.toString().split('.').last}

Please consider this data when providing advice and recommendations.
""";
    } else {
      baseContext += """

Note: No current sensor data is available. Provide general plant care advice and suggest connecting to the device for personalized recommendations.
""";
    }

    return baseContext;
  }

  void clearMessages() {
    _messages.clear();
    _addWelcomeMessage();
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}