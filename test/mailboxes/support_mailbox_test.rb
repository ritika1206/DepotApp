require "test_helper"

class SupportMailboxTest < ActionMailbox::TestCase
  test "Create SupportRequest when we get support email" do
    receive_inbound_email_from_mail(
      to: "support@example.com", 
      from: "chris@somewhere.net", 
      subject: "Need help",
      body: "I can't figure out how to check out!!"
    )

    support_request = SupportRequest.last
    assert_equal "chris@somewhere.net", support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body

    # User not having any last order should have order as nil
    assert_nil support_request.order
  end

  test "Create SupportRequest with most recent Order" do
    recent_order = orders(:one)
    older_order = orders(:another_one)
    non_customer = orders(:other_customer)

    receive_inbound_email_from_mail(
      to: "support@example.com", 
      from: recent_order.email, 
      subject: "Need help",
      body: "I can't figure out how to check out!!"
    )

    support_request = SupportRequest.last
    assert_equal recent_order.email, support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body 
    assert_equal recent_order, support_request.order
  end
end
