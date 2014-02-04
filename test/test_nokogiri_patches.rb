require_relative 'helper'
require 'pry'

describe 'Nokogiri' do
  def html_to_nokogiri(html)
    Nokogiri::HTML.fragment(html)
  end

  def deindent(source)
    split_source = source.split("\n")
    split_source = split_source.map{|x| x.rstrip}
    split_source = split_source.select{|x| x != ""}
    min_space    = split_source.min{|x| x.count(" ")}.count(" ")
    split_source = split_source.map{|x| x[min_space..-1]}.join("\n")
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
