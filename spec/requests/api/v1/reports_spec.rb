require 'rails_helper'

RSpec.describe "Api::V1::Reports", type: :request do
  describe 'POST /api/v1/reports' do
    let(:report) { FactoryBot.create(:report) }
    let(:valid_params) { FactoryBot.attributes_for(:report) }

    let(:user) { FactoryBot.create(:user) }
    let(:auth_token) { FactoryBot.create(:auth_token, user: user) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }

    context "with valid parameters" do
      before do
        post "/api/v1/reports", params: valid_params, headers: token
      end

      it "returns HTTP status 201" do
        expect(response).to have_http_status(201)
      end

      it "creates a new report" do
        expect(Report.count).to eq(1)
      end

      it "returns the report and transactions" do
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Report Creation Successful 👍")
        expect(json["report"]["start_date"]).to eq(report.start_date.iso8601)
        expect(json["report"]["end_date"]).to eq(report.end_date.iso8601)
        expect(json["transactions"].size).to eq(user.transactions.size)
      end
    end

    context "with invalid parameters" do
      before do
        post "/api/v1/reports", params: { start_date: nil, end_date: nil }, headers: token
      end

      it "returns HTTP status 422" do
        expect(response).to have_http_status(422)
      end

      it "returns errors" do
        json = JSON.parse(response.body)
        expect(json["errors"]).to eq(["Start date can't be blank", "Start date must be at least a week ago, and not more than past 120 days❗", "End date can't be blank", "End date must be at most a week ago, and not more than the current time❗"])
      end
    end

    context "without authentication token" do
      before do
        post "/api/v1/reports", params: valid_params
      end

      it "returns HTTP status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end
end
