# lib/chat_gpt_error_handler/error_handler.rb
require 'openai'

module ChatGptErrorHandler
  class ErrorHandler
    def initialize(app)
      @app = app
      if ChatGptErrorHandler.enabled
        OpenAI.configure do |config|
          config.access_token = ChatGptErrorHandler.openai_access_token || ENV.fetch('OPENAI_ACCESS_TOKEN')
        end
      end
    end

    def call(env)
      begin
        @app.call(env)
      rescue => error
        send_to_gpt(error) if ChatGptErrorHandler.enabled
        raise error
      end
    end

    private

    def send_to_gpt(error)
      begin
        client = OpenAI::Client.new

        prompt = "
        You are a helpful bot that I have created inside of a Rails engine that
        someone has installed into their Rails app. You will get a text error message
        from their terminal. With this error message, you will try to help them
        fix the error. Clearly list possible reasons and a solution.
        Your answer will be displayed in the terminal for the user to see right
        before the backtrace of the error. Do NOT repeat the error message back verbatim.
        I will give you the error and I want the possible reason or solution?"

        query = error.message

        response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo-0613",
          messages: [
            { role: "system", content: prompt },
            { role: "user", content: query },
          ],
          temperature: 0.85,
        },
      )

        response_text = if response["choices"].nil?
          "GPT returned an empty response to your error message."
        else
          response["choices"][0]["message"]["content"]
        end

        shortened_response_text = []
        begin
          # try to format the response text to be 75 characters per line
          response_text.split(" ").reduce("") do |line, word|
            if line.length + word.length > 75
              shortened_response_text << line
              line = word
            elsif word == response_text.split(" ").last
              shortened_response_text << [line + " " + word]
            else
              line += (" " + word)
            end
          end
          shortened_response_text = shortened_response_text.join("\n")
        rescue => e
          # The formatting does not always work, so if it fails, just use the original response text
          shortened_response_text = response_text
        end

        print_error_and_solution(error, shortened_response_text.strip)
      rescue => gpt_error
        puts "\e[31mAn error occurred while communicating with GPT:\e[0m"
        puts gpt_error.message
        puts gpt_error.backtrace
      end
    end

    def print_error_and_solution(error, response_text)
      puts "\e[31;1mOriginal error message:\e[0m\n\n"
      puts error.message
      puts "\n\n\e[34;1mChatGPT's best guess to remedy the error:\e[0m"
      puts "\n"
      puts response_text
      puts "\n\n\e[34;1mFull stacktrace:\e[0m"
    end
  end
end
