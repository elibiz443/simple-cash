class Api::V1::ReportsController < ApplicationController
  def create
    user_token = TokenServices.new.user_token(request)

    start_date = params[:start_date]
    end_date = params[:end_date]
    user_id = user_token.user_id
    
    @report = Report.new(start_date: start_date, end_date: end_date, user_id: user_id)
    @transactions = Transaction.where(user_id: user_id, created_at: start_date..end_date)

    if @report.save
      transactions = @transactions
      start_date_object = Time.parse(start_date)
      end_date_object = Time.parse(end_date)
      info = "The following are all your transactions between: #{start_date_object.strftime('%a, %d %b %Y')} to #{end_date_object.strftime('%a, %d %b %Y')}."
      recipient_email = User.find_by_id(user_id).email
      MailServices.new.send_report(info, recipient_email, transactions)

      render json: { message: "Report Creation Successful 👍", report: @report, transactions: @transactions }, status: :created
    else
      render json: { errors: @report.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
