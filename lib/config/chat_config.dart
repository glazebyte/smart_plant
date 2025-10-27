class ChatConfig {
  // Replace this with your actual OpenRouter API key
  // You can get one from: https://openrouter.ai/keys
  static const String openRouterApiKey = "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";
  
  // OpenRouter configuration
  static const String baseUrl = "https://openrouter.ai/api/v1";
  static const String defaultModel = "tngtech/deepseek-r1t2-chimera:free"; // Cost-effective model
  // Alternative models you can use:
  // "openai/gpt-3.5-turbo" - OpenAI's GPT-3.5
  // "anthropic/claude-3-sonnet" - Claude 3 Sonnet
  // "meta-llama/llama-3.1-8b-instruct" - Free Llama model
  // "microsoft/wizardlm-2-8x22b" - Free high-quality model
  // "tngtech/deepseek-r1t2-chimera:free" - Free DeepSeek model
  
  static const int maxTokens = 500;
  static const double temperature = 0.7;
  static const int maxConversationHistory = 10;
  
  // Plant-specific assistant configuration
  static const String assistantName = "Smart Plant Assistant";
  static const String assistantRole = "Plant Care Expert";
  
  // App identification for OpenRouter (optional but recommended)
  static const String appName = "Smart Plant Monitor";
  static const String appUrl = "https://github.com/glazebyte/smart_plant";
}