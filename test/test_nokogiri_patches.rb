require_relative 'helper'
require 'pry'

  require 'slim'
  require 'slim/grammar'

  # Slim::Engine.after  Slim::Parser, Temple::Filters::Validator, :grammar => Slim::Grammar
  # Slim::Engine.before :Pretty, Temple::Filters::Validator

describe 'Nokogiri' do
  def html_to_nokogiri(html)
    Nokogiri::HTML.fragment(html)
  end

  def deindent(source)
    split_source = source.split("\n")
    split_source = split_source.select{|x| x.strip != ""}
    min_space    = split_source.map{|x| x.match(/^\s+/).to_s.size }.min
    split_source = split_source.map{|x| x[min_space..-1]}.join("\n")
  end


  def assert_html(expected, source, options = {}, &block)
    assert_equal expected, render(source, options, &block)
  end

  def render(source, options = {}, &block)
    scope = options.delete(:scope)
    locals = options.delete(:locals)
    Slim::Template.new(options[:file], options) { source }.render(scope || {}, locals, &block)
  end

  it "works for simple cases" do
    res      = html_to_nokogiri(%Q{<div class='main'>somecontent</div>})
    expected = deindent %Q{
      .main
        | somecontent
    }
    (res.to_slim).must_equal expected
  end

  it "works for links" do
    res      = html_to_nokogiri(%Q{<a  href='/some-url' class='main'>Click Me</a>})
    expected = deindent %Q{
      a.main[href=\"/some-url\"]
        | Click Me
    }
    (res.to_slim).must_equal expected
  end

  it "render test" do
    source = deindent %q{
    = "<p>Hello</p>"
    == "<p>World</p>"
    }

    assert_html "<p>Hello</p><p>World</p>", source, :disable_escape => true
  end


  it "deindent" do
    source = %Q{
      html
        body
          div.main
            | hey but this work fine or not
    }
    res = <<SRC
html
  body
    div.main
      | hey but this work fine or not
SRC
    deindent(source).must_equal res.strip
  end

end
