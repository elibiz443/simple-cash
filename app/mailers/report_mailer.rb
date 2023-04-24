class ReportMailer < ApplicationMailer
  def send_info_email(info, recipient_email, transactions)
    @info = info
    @transactions = transactions
    mail(to: recipient_email, subject: "Transaction Report")
  end
end
