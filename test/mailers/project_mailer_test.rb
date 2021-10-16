require "test_helper"

class ProjectMailerTest < ActionMailer::TestCase
  test "notify_client" do
    mail = ProjectMailer.notify_client
    assert_equal "Notify client", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
