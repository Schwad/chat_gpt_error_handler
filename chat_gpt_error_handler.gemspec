require_relative "lib/chat_gpt_error_handler/version"

Gem::Specification.new do |spec|
  spec.name        = "chat_gpt_error_handler"
  spec.version     = ChatGptErrorHandler::VERSION
  spec.authors     = ["Nick Schwaderer"]
  spec.email       = ["nick.schwaderer@shopify.com"]
  spec.homepage    = "https://github.com/schwad/chat_gpt_error_handler"
  spec.summary     = "Helpful ChatGpt hints for your Rails app"
  spec.description = "Helpful ChatGpt hints for your Rails app"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.3"
  spec.add_dependency "ruby-openai"
end
