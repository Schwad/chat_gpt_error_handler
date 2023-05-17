require "chat_gpt_error_handler/version"
require "chat_gpt_error_handler/engine"

module ChatGptErrorHandler
    mattr_accessor :openai_access_token

  # Default value for the openai_access_token, used when not explicitly set by the user
  @@openai_access_token = nil
end
