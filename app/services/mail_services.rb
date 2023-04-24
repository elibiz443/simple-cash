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

  def send_report(info, recipient_email, transactions)
    begin
      ReportMailer.send_info_email(info, recipient_email, transactions).deliver_later
    rescue StandardError
      "error!"
    else
      "passed!"
    end
  end
end
