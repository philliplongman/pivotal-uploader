require "bundler/setup"
require "bundler"
require "pivotal-tracker"
require "dotenv"
require "thor"

require_relative "models/markdown_story"

Dotenv.load

PivotalTracker::Client.token = ENV["API_TOKEN"]

class PTMarkdown < Thor
  desc "upload FILE", "parse Markdown file into Pivotal Tracker stories"

  def upload(file_arg)
    file = file_arg.dup
    file << ".md" unless file.end_with? ".md"

    MarkdownStory.parse(file).each(&:upload)
  end
end

PTMarkdown.start(ARGV)
