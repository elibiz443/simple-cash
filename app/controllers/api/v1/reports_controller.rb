class Api::V1::ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_token = TokenServices.new.user_token(request)

    start_date = params[:start_date]
    end_date = params[:end_date]
    user_id = user_token.user_id
    
    @report = Report.new(start_date: start_date, end_date: end_date, user_id: user_id)

    if @report.save
      @transactions = Transaction.where(user_id: @report.user_id, created_at: @report.start_date..@report.end_date)
      render json: { message: "Report Creation Successful 👍", report: @report, transactions: @transactions }, status: :created
    else
      render json: { errors: @report.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
