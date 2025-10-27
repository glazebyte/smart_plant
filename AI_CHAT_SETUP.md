# AI LLM Chat Feature Setup (OpenRouter Integration)

This document explains how to set up and use the AI Plant Assistant chat feature in your Smart Plant monitoring app using OpenRouter.

## Overview

The AI Plant Assistant is an intelligent chatbot that can:
- Provide plant care advice
- Interpret your sensor data
- Answer questions about plant health
- Give personalized recommendations based on your plant's current conditions

**Why OpenRouter?**
- Access to multiple AI models (Claude, GPT, Llama, etc.)
- Cost-effective pricing
- No need for separate API keys for different providers
- Free models available
- Better rate limits

## Setup Instructions

### 1. Get OpenRouter API Key

1. Visit [OpenRouter](https://openrouter.ai/keys)
2. Sign up or log in to your account
3. Create a new API key
4. Copy the API key (it starts with `sk-or-v1-`)

### 2. Configure the App

1. Open `lib/config/chat_config.dart`
2. Replace the API key with your actual OpenRouter API key:
   ```dart
   static const String openRouterApiKey = "sk-or-v1-your-actual-api-key-here";
   ```

### 3. Choose Your AI Model

OpenRouter supports many models. In `chat_config.dart`, you can change the `defaultModel`:

#### Free Models (No cost):
- `"meta-llama/llama-3.1-8b-instruct"` - Meta's Llama 3.1 8B
- `"microsoft/wizardlm-2-8x22b"` - Microsoft's WizardLM 2
- `"tngtech/deepseek-r1t2-chimera:free"` - DeepSeek model

#### Low-Cost Models:
- `"anthropic/claude-3.5-haiku"` - Claude 3.5 Haiku (fast & cheap)
- `"openai/gpt-3.5-turbo"` - OpenAI's GPT-3.5

#### High-Quality Models:
- `"anthropic/claude-3-sonnet"` - Claude 3 Sonnet
- `"openai/gpt-4"` - OpenAI's GPT-4

### 4. Dependencies

The app uses these packages for the chat functionality:
- `http: ^1.1.0` - For HTTP requests to OpenRouter
- `markdown_widget: ^2.3.2+6` - For rendering markdown in AI responses

## Features

### Chat Interface
- Modern bubble-style chat interface with **markdown rendering**
- Real-time typing indicators
- Message timestamps
- Error handling and retry capabilities
- Rich text formatting for AI responses (headers, lists, code blocks, etc.)

### Plant-Specific Context
The AI assistant has access to:
- Current soil moisture levels
- Temperature readings
- Humidity data
- Historical sensor trends
- Plant care best practices

### Multilingual Support
- English and Indonesian language support
- Localized UI elements
- Context-aware responses

## Usage

1. **Navigate to Chat**: Tap the chat icon in the bottom navigation
2. **Start Conversation**: Type your question about plant care
3. **Get Advice**: The AI will provide personalized recommendations
4. **Context Awareness**: When your device is connected, the AI can see your current sensor data

### Example Questions
- "Is my plant getting enough water?"
- "What does a soil moisture of 45% mean?"
- "How often should I water my plant?"
- "The temperature is 28°C, is that good for my plant?"
- "My humidity is low, what should I do?"

### Markdown Rendering Features

The AI assistant can format responses with rich text including:

- **Headers** (`## Section Title`)
- **Bold text** (`**important**`)
- **Italic text** (`*emphasis*`)
- **Lists** (bullet points and numbered)
- **Code blocks** (```code```)
- **Inline code** (`code`)
- **Blockquotes** (`> tip`)

Example AI response with markdown:
```
## Plant Assessment
Your soil moisture is at **45%** - this is in the `moderate` range.

### Recommendations:
- **Monitor** for the next 2-3 days
- **Water** when it drops below 30%
- **Check** drainage if it stays above 70%

> **Tip**: Most houseplants prefer soil moisture between 40-60%
```

## Configuration Options

In `lib/config/chat_config.dart`, you can customize:

```dart
// API Configuration
static const String openRouterApiKey = "your-key-here";
static const String baseUrl = "https://openrouter.ai/api/v1";
static const String defaultModel = "anthropic/claude-3.5-haiku";

// Chat Behavior
static const int maxTokens = 500;           // Response length
static const double temperature = 0.7;      // Creativity (0.0-1.0)
static const int maxConversationHistory = 10; // Messages to remember

// App Identification
static const String appName = "Smart Plant Monitor";
static const String appUrl = "https://github.com/your-username/smart-plant";
```

## Model Comparison

| Model | Cost | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| Llama 3.1 8B | Free | Fast | Good | General chat, testing |
| Claude 3.5 Haiku | Low | Very Fast | High | Production use |
| Claude 3 Sonnet | Medium | Medium | Very High | Complex plant questions |
| GPT-3.5 Turbo | Low | Fast | High | Balanced performance |
| GPT-4 | High | Slow | Highest | Expert-level advice |

## Security Notes

⚠️ **Important**: 
- Never commit your actual API key to version control
- Consider using environment variables or secure storage in production
- Monitor your OpenRouter usage to avoid unexpected charges
- The current implementation includes the API key in the app bundle - for production, use secure key management

## Cost Management

OpenRouter pricing:
- Many free models available
- Pay-per-use pricing for premium models
- No monthly fees
- Transparent pricing on their website
- Usage tracking in dashboard

## Troubleshooting

### Common Issues

1. **"API Key Error"**: 
   - Verify your OpenRouter API key is correct
   - Check you have credits in your OpenRouter account
   - Ensure the key starts with `sk-or-v1-`

2. **"Network Error"**: 
   - Check internet connection
   - Verify OpenRouter service status at https://status.openrouter.ai

3. **"Model Not Found"**: 
   - Check the model name is correct
   - Some models may not be available in your region
   - Try a different model from the supported list

4. **"Rate Limited"**: 
   - OpenRouter has generous rate limits
   - Wait a moment and try again
   - Consider upgrading your OpenRouter plan

### API Response Errors

- **400 Bad Request**: Check your request format
- **401 Unauthorized**: Invalid API key
- **429 Too Many Requests**: Rate limited
- **500 Server Error**: OpenRouter service issue

## Technical Implementation

### Architecture
- Direct HTTP calls to OpenRouter API
- No external SDKs required
- Efficient JSON communication
- Proper error handling and retries

### Key Components
- `ChatProvider`: Manages chat state and OpenRouter integration
- `ChatMessage`: Data model for individual messages
- `ChatScreen`: UI for the chat interface
- `ChatConfig`: Configuration and API key management

### API Integration
```dart
// OpenRouter API endpoint
POST https://openrouter.ai/api/v1/chat/completions

// Headers
Authorization: Bearer sk-or-v1-your-api-key
Content-Type: application/json
HTTP-Referer: your-app-url
X-Title: your-app-name

// Request body
{
  "model": "anthropic/claude-3.5-haiku",
  "messages": [...],
  "max_tokens": 500,
  "temperature": 0.7
}
```

## Advantages of OpenRouter

1. **Multiple Models**: Access GPT, Claude, Llama, and more with one API
2. **Cost Effective**: Competitive pricing, often cheaper than direct APIs
3. **Free Options**: Several high-quality free models available
4. **No Vendor Lock-in**: Easy to switch between models
5. **Transparent Pricing**: Clear per-token costs
6. **Good Rate Limits**: Generous usage allowances
7. **Active Community**: Strong developer support

## Future Enhancements

Potential improvements for the chat feature:
- Model switching within the app
- Cost tracking and usage analytics
- Conversation export/import
- Voice input/output
- Image analysis of plants
- Integration with plant care databases
- Scheduled reminders based on AI recommendations
- Offline fallback responses