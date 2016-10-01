# Require all the things
require "bundler/setup"
Bundler.require
Dotenv.load
Dir.glob("./models/*", &method(:require))

binding.pry
