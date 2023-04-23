class MailServices
  def send_mail(info, recipient_email)
    begin
      InfoMailer.send_info_email(info, recipient_email).deliver_now
    rescue StandardError
      "error!"
    else
      "passed!"
    end
  end
end
