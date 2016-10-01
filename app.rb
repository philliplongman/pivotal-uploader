# Require all the things
require "bundler/setup"
Bundler.require
Dotenv.load
Dir.glob "./models/*", &method(:require)

PivotalTracker::Client.token = ENV["API_TOKEN"]

file = "test-file.md"

MarkdownStory.parse(file).each(&:upload)
