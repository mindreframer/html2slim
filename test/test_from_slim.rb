require_relative 'helper'

describe :test_cases_from_slim do
  include TestCommonMethods
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
      html_from_slim = render_slim(slim)
      html_from_slim.must_equal test_case[:html]
    end
  end
end
