require 'bundler'
Bundler.setup
require 'html2slim'
puts "html2slim loaded..."

html = File.read("test/fixtures/slim-lang.html")
#HTML2Slim::NOKOHTMLConverter.new(html)

HTML2Slim::HTMLConverter.new(html)