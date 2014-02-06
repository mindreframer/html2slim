require 'bundler'
Bundler.setup
require 'html2slim'
require 'slim'
require 'open-uri'

puts "html2slim loaded..."

def render(source, options = {}, &block)
  scope = options.delete(:scope)
  locals = options.delete(:locals)
  Slim::Template.new(options[:file], options) { source }.render(scope || {}, locals, &block)
end
