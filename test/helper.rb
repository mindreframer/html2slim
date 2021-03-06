require 'rubygems'
require 'minitest/autorun'
require 'slim'
require_relative '../lib/html2slim'

MiniTest.autorun

require 'pry'

module TestCommonMethods
  def deindent(source)
    split_source = source.split("\n")
    split_source = split_source.select{|x| x.strip != ""}
    min_space    = split_source.map{|x| x.match(/^\s+/).to_s.size }.min
    split_source = split_source.map{|x| x[min_space..-1]}.join("\n")
  end

  def render_slim(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new(options[:file], options) { source }.render(scope || {}, locals, &block)
  end

  def assert_html(expected, source, options = {}, &block)
    assert_equal expected, render_slim(source, options, &block)
  end

  def html_to_nokogiri(html)
    if html.include?('<html')
      Nokogiri::HTML(html)
    else
      Nokogiri::HTML.fragment(html)
    end
  end

  def html_to_hpricot(html)
    Hpricot(html)
  end

  def html_to_slim(html)
    HTML2Slim::HTMLConverterNokogiri.new(html).to_s
  end

  def erb_to_slim(erb)
    HTML2Slim::ERBConverter.new(erb).to_s
  end

  def fixture(filename)
    File.read(File.join('test/fixtures', filename))
  end

  def assert_erb_to_slim(erb, slim)
    result   = erb_to_slim(erb)
    expected = deindent(slim)
    result.must_equal expected
  end
end