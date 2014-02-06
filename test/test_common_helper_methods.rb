require_relative 'helper'

describe :helper_methods do
  include TestCommonMethods

  describe :render_slim do
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
