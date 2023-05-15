require_relative 'error_handler'
module ChatGptErrorHandler
  class Engine < ::Rails::Engine
    isolate_namespace ChatGptErrorHandler

    initializer "chat_gpt_error_handler.use_middleware" do |app|
      app.middleware.use ChatGptErrorHandler::ErrorHandler
    end
  end
end
