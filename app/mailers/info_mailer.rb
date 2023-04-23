class InfoMailer < ApplicationMailer
  def send_info_email(info, recipient_email)
    @info = info
    mail(to: recipient_email, subject: "Cash Transaction")
  end
end
