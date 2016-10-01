# Require all the things
require "bundler/setup"
Bundler.require
Dotenv.load
Dir.glob("./models/*", &method(:require))

stories = MarkdownStory.parse "test-file.md"
