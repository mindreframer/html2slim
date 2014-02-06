require_relative 'helper'

describe 'Nokogiri' do
  include TestCommonMethods
  extend TestCommonMethods

  describe :test_cases_to_slim do
    test_cases = [
      {
        :html => %Q{<div class='main'>somecontent</div>},
        :slim => %Q{
      .main
        | somecontent}
      }, {
        :html => %Q{<a  href='/some-url' class='main'>Click Me</a>},
        :slim => %Q{
      a.main[href=\"/some-url\"]
        | Click Me}
      }, {
        :html => %Q{<!-- hey comment--> <div id="footer" class="bold">some content</div>},
        :slim => %Q{
          /!  hey comment
          #footer.bold
            | some content
        }
      }, {
        :html => fixture('slim-lang.html'),
        :slim => fixture('slim-lang.slim')
      }, {
        :html => '<a href="test" data-param1="var" data-param2="(1 + 1)" data-param3="string"></a>',
        :slim => 'a[href="test" data-param1="var" data-param2="(1 + 1)" data-param3="string"]'
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
end
