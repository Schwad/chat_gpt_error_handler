Rails.application.routes.draw do
  mount ChatGptErrorHandler::Engine => "/chat_gpt_error_handler"
end
