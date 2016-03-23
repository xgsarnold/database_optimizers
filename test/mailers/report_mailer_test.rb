require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test "search_results" do
    mail = ReportMailer.search_results
    assert_equal "Search results", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
