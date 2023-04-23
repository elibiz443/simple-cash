require 'rails_helper'

RSpec.describe "Api::V1::TopUps", type: :request do
  describe 'POST /api/v1/top_ups' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_params) { { amount: 100, phone_number: user.phone_number } }
    let(:invalid_params) { { amount: 0, phone_number: "" } }
    let(:non_existent_user) { FactoryBot.attributes_for(:top_up) }

    let(:auth_token) { FactoryBot.create(:auth_token, user: user) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }

    context "when user is authenticated" do
      context "with valid params" do
        it "creates a new top-up" do
          expect {
            post "/api/v1/top_ups", params: valid_params, headers: token
          }.to change(TopUp, :count).by(1)
        end

        it "increases the user balance by the top-up amount" do
          expect {
            post "/api/v1/top_ups", params: valid_params, headers: token
          }.to change { user.reload.balance }.by(valid_params[:amount])
        end

        it "returns a success message" do
          post "/api/v1/top_ups", params: valid_params, headers: token
          expect(response).to have_http_status(:created)
          expect(response.body).to include("Top Up Successful 👍")
        end
      end

      context "with invalid params" do
        it "does not create a new top-up" do
          expect {
            post "/api/v1/top_ups", params: invalid_params, headers: token
          }.not_to change(TopUp, :count)
        end

        it "returns an error message" do
          post "/api/v1/top_ups", params: invalid_params, headers: token
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Amount must be present or greater than 0❗")
        end
      end

      context "when user does not exist" do
        it "does not create a new top-up" do
          expect {
            post "/api/v1/top_ups", params: non_existent_user, headers: token
          }.not_to change(TopUp, :count)
        end

        it "returns an error message" do
          post "/api/v1/top_ups", params: non_existent_user, headers: token
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Phone number does not exist 🚫")
        end
      end
    end

    context "when user is not authenticated" do
      it "returns an unauthorized error message" do
        post "/api/v1/top_ups", params: valid_params
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("Invalid token!")
      end
    end
  end
end
