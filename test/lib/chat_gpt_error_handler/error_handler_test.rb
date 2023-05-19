require "test_helper"

module ChatGptErrorHandler
  class MockApp
    def call(env)
    end
  end

  class ErrorHandlerTest < ActiveSupport::TestCase
    test "ErrorHandler instantiates successfully by default" do
      app = MockApp.new

      assert_nothing_raised do
        ChatGptErrorHandler::ErrorHandler.new(app)
      end
    end

    test "if you enable ChatGptErrorHandler it needs, and sets, an access token" do
      ChatGptErrorHandler.openai_access_token = 'acc3ss-t0k3n'
      ChatGptErrorHandler.enabled = true

      app = MockApp.new

      ChatGptErrorHandler::ErrorHandler.new(app)

      assert_equal OpenAI.configuration.access_token, 'acc3ss-t0k3n'
    end

    test "if you enable ChatGptErrorHandler you also need an access token" do
      ChatGptErrorHandler.enabled = true

      app = MockApp.new

      exception = assert_raises KeyError do
        ChatGptErrorHandler::ErrorHandler.new(app)
      end
      assert_equal 'key not found: "OPENAI_ACCESS_TOKEN"', exception.message
    end
  end
end
