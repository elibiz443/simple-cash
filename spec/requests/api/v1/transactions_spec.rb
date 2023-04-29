require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  describe "POST /api/v1/transactions" do
    let(:sender) { FactoryBot.create(:user) }
    let(:recipient) { FactoryBot.create(:user) }
    let(:valid_params) { { amount: 100, phone_number_or_email: recipient.email } }
    let(:invalid_params) { { amount: 0, phone_number_or_email: "" } }

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
          expect(response.body).to include("Phone number or email can't be blank")
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
    let(:sender) { FactoryBot.create(:user, first_name: "John", last_name: "Doe") }
    let(:recipient) { FactoryBot.create(:user, balance: 27225.82) }
    let(:full_name) { sender.first_name.to_s + " " + sender.last_name.to_s }
    let(:valid_params) { { amount: 100.0, phone_number_or_email: recipient.email } }
    let(:auth_token) { FactoryBot.create(:auth_token, user: sender) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }
    let(:notification) { FactoryBot.create(:notification) }
    let(:valid_notification_params) { { user: FactoryBot.attributes_for(:notification) } }
    let(:new_notification_params) { { user: FactoryBot.attributes_for(:notification, status: "read") } }
    let!(:notification_to_delete) { FactoryBot.create(:notification) }


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

    context "with notifications params" do
      context "When requesting all notifications of a user" do
        it "returns a success message" do
          get "/api/v1/notifications", headers: token
          expect(response).to have_http_status(:ok)
        end
      end

      context "When requesting particular notification of a user" do
        it "returns a success message" do
          get "/api/v1/notifications/#{notification.to_param}", headers: token
          expect(response).to have_http_status(:ok)
        end
      end

      context "When updating notification" do
        it "updates the requested notification" do
          patch "/api/v1/notifications/#{notification.id}", params: new_notification_params, headers: token
          notification.reload
          expect(notification.status).to eq("read")
        end

        it "returns a success response" do
          patch "/api/v1/notifications/#{notification.id}", params: valid_notification_params, headers: token
          expect(response).to have_http_status(:ok)
        end
      end

      context "When deleting notification" do
        it "deletes the requested notification and returns a success response" do
          expect {
            delete "/api/v1/notifications/#{notification_to_delete.id}", headers: token
          }.to change(Notification, :count).by(-1)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include("Notification deleted successfully ❌")
        end
      end
    end
  end
end
