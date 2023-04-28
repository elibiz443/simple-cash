class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_token = TokenServices.new.user_token(request)

    amount = params[:amount].to_f
    phone_number_or_email = params[:phone_number_or_email]
    user_id = user_token.user_id

    @transaction = Transaction.new(amount: amount, phone_number_or_email: phone_number_or_email, user_id: user_id)

    if @transaction.save
      sender = User.find_by(id: user_id)
      recipient = User.find_by(phone_number: phone_number_or_email) || User.find_by(email: phone_number_or_email)

      unique_code = SecureRandom.hex(3).upcase + "-" + sender.id.to_s + recipient.id.to_s + @transaction.id.to_s
      full_name = sender.first_name.to_s + " " + sender.last_name.to_s

      sender.update(balance: (sender.balance - amount))
      recipient.update(balance: (recipient.balance + amount))

      info = "#{unique_code} Confirmed. You have received Ksh#{amount} from #{full_name} #{sender.phone_number} on #{(Time.now).strftime("%d/%m/%y")} at #{(Time.now).strftime("%H:%M %p")} new balance is Ksh#{recipient.balance}"
      recipient_email = recipient.email
      
      Notification.create(detail: "#{info}", user_id: recipient.id)
      MailServices.new.send_mail(info, recipient_email)

      render json: { message: "Transaction Successful 👍 Remaining Balance: #{sender.balance}", user_balance: sender.balance, recipient_balance: recipient.balance, transaction: @transaction }, status: :created
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
