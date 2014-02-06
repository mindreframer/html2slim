require_relative 'helper'

describe :test_cases_from_erb do
  include TestCommonMethods
  test_cases = [
    {
      :erb => %Q{<% a = 1 %>},
      :slim => %Q{- a = 1}
    },
    {
      :erb => %Q{<%= @a.b %>},
      :slim => %Q{= @a.b}
    }
  ]

  test_cases.each_with_index do |test_case, index|
    it "works for testcase #{index}" do
      result   = erb_to_slim(test_case[:erb])
      expected = deindent(test_case[:slim])
      result.must_equal expected
    end
  end
end


# assert_erb_to_slim '<% a = 1 %>', '- a = 1'
# # simple = (puts)
# assert_erb_to_slim '<%= @a.b %>', '= @a.b'
# # no block
# assert_erb_to_slim '<% @a %>SOME<% @b %>', "- @a\n| SOME\n- @b"
# # block with do
# assert_erb_to_slim '<% @a.each do |yay| %>SOME<% yay %><% end %>', "- @a.each do |yay|\n  | SOME\n  - yay"
# # block with { and on var
# assert_erb_to_slim '<% @a.each { |yay| %>SOME<% yay %><% } %>', "- @a.each do |yay|\n  | SOME\n  - yay"
# # block without vars
# assert_erb_to_slim '<% 10.times { %>SOME<% yay %><% } %>', "- 10.times do\n  | SOME\n  - yay"
# # if
# assert_erb_to_slim '<% if 1 == 1 %>SOME<% yay %><% end %>', "- if 1 == 1\n  | SOME\n  - yay"
# # else
# assert_erb_to_slim '<% if 1 == 1 %>SOME<% yay %><% else %>OTHER<% end %>', "- if 1 == 1\n  | SOME\n  - yay\n- else\n  | OTHER"
# # elsif
# assert_erb_to_slim '<% if 1 == 1 %>SOME<% yay %><% elsif 2 == 2 %>OTHER<% end %>', "- if 1 == 1\n  | SOME\n  - yay\n- elsif 2 == 2\n  | OTHER"
# # case/when
# assert_erb_to_slim '<% case @foo %><% when 1 %>1<% when 2 %>2<% else %>3<% end %>', "- case @foo\n- when 1\n  | 1\n- when 2\n  | 2\n- else\n  | 3"
# # while
# assert_erb_to_slim '<% while @foo.next %>NEXT<% end %>', "- while @foo.next\n  | NEXT"
# # all togheter and mixed
# assert_erb_to_slim '<% while @foo.next %><% if 1 == 1 %><% for i in @foo.bar %>WORKS<% end %><% end %><% end %>', "- while @foo.next\n  - if 1 == 1\n    - for i in @foo.bar\n      | WORKS"