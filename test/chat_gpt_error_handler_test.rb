require "test_helper"

class ChatGptErrorHandlerTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert ChatGptErrorHandler::VERSION
  end

  test "you can enable the module" do
    refute ChatGptErrorHandler.enabled

    ChatGptErrorHandler.enabled = true

    assert ChatGptErrorHandler.enabled
  end
end
