require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  describe "POST /api/v1/transactions" do
    let(:sender) { FactoryBot.create(:user) }
    let(:recipient) { FactoryBot.create(:user) }
    let(:valid_params) { { amount: 100, phone_number: recipient.phone_number } }
    let(:invalid_params) { { amount: 0, phone_number: "" } }

    let(:auth_token) { FactoryBot.create(:auth_token, user: sender) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }

    context "when user is authenticated" do
      context "with valid params" do
        it "creates a new transaction" do
          expect {
            post "/api/v1/transactions", params: valid_params, headers: token
          }.to change(Transaction, :count).by(1)
        end

        it "updates the sender and recipient balances" do
          expect {
            post "/api/v1/transactions", params: valid_params, headers: token
            sender.reload
            recipient.reload
          }.to change(sender, :balance).by(-100).and change(recipient, :balance).by(100)
        end

        it "returns a success message" do
          post "/api/v1/transactions", params: valid_params, headers: token
          expect(response).to have_http_status(:created)
          expect(response.body).to include("Transaction Successful 👍")
        end
      end

      context "with invalid params" do
        before do
          post "/api/v1/transactions", params: invalid_params, headers: token
        end

        it "returns a 422 status code" do
          expect(response).to have_http_status(422)
        end

        it "returns an error message" do
          expect(response.body).to include("Amount must be present or greater than 0❗")
          expect(response.body).to include("Phone number can't be blank")
        end
      end
    end

    context "when user is not authenticated" do
      it "returns an unauthorized error message" do
        post "/api/v1/transactions", params: valid_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("Invalid token!")
      end
    end
  end

  describe "POST /notifications" do
    let(:sender) { FactoryBot.create(:user) }
    let(:recipient) { FactoryBot.create(:user, balance: 27225.82) }
    let(:full_name) { sender.first_name.to_s + " " + sender.last_name.to_s }
    let(:valid_params) { { amount: 100.0, phone_number: recipient.phone_number } }
    let(:auth_token) { FactoryBot.create(:auth_token, user: sender) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }

    context "with valid params" do
      before do
        post "/api/v1/transactions", params: valid_params, headers: token
      end

      it "creates a notification for the recipient" do
        expect(Notification.last.detail).to include(full_name)
        expect(Notification.last.user_id).to eq(recipient.id)
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([recipient.email])
        expect(ActionMailer::Base.deliveries.last.body).to include(full_name)
      end
    end
  end
end
