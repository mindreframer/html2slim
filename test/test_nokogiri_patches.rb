require_relative 'helper'
require 'pry'

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


  describe :test_cases_to_slim do
    test_cases = [
      {
        :html => %Q{<div class='main'>somecontent</div>},
        :slim => %Q{
      .main
        | somecontent}
      },
      {
        :html => %Q{<a  href='/some-url' class='main'>Click Me</a>},
        :slim => %Q{
      a.main[href=\"/some-url\"]
        | Click Me}
      },
      {
        :html => %Q{<!-- hey comment--> <div id="footer" class="bold">some content</div>},
        :slim => %Q{
          /!  hey comment
          #footer.bold
            | some content
        }
      }
    ]

    test_cases.each_with_index do |test_case, index|
      it "works for testcase #{index}" do
        result   = html_to_nokogiri(test_case[:html]).to_slim
        expected = deindent(test_case[:slim])
        result.must_equal expected
      end
    end
  end


describe :test_cases_from_slim do
    test_cases = [
      {
        :html => %Q{<div class="main">somecontent</div>},
        :slim => %Q{
      .main
        | somecontent}
      },
      {
        :html => %Q{<a class="main" href="/some-url">Click Me</a>},
        :slim => %Q{
      a.main[href=\"/some-url\"]
        | Click Me}
      }
    ]

    test_cases.each_with_index do |test_case, index|
      it "works for testcase #{index}" do
        slim           = deindent(test_case[:slim])
        html_from_slim = render(slim)
        html_from_slim.must_equal test_case[:html]
      end
    end
  end

  describe :helper_methods do

    describe :render do
      it "works" do
        source = deindent %q{
        = "<p>Hello</p>"
        == "<p>World</p>"
        }

        assert_html "<p>Hello</p><p>World</p>", source, :disable_escape => true
      end
    end

    describe :deindent do
      it "works" do
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
  end
end
