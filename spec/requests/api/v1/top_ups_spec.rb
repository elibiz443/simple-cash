require 'rails_helper'

RSpec.describe "Api::V1::TopUps", type: :request do
  describe 'POST /api/v1/top_ups' do
    let(:user) { FactoryBot.create(:user, phone_number: "245-780-8171 x783") }
    let(:valid_top_up) { FactoryBot.attributes_for(:top_up, phone_number: user.phone_number) }
    let(:invalid_attributes) { FactoryBot.attributes_for(:top_up, amount: 0) }
    let(:non_existent_user) { FactoryBot.attributes_for(:top_up) }
    let(:auth_token) { FactoryBot.create(:auth_token) }
    let!(:token) { { "Authorization" => "Bearer #{ auth_token.token_digest }" } }

    context "when user is authenticated" do
      context "with valid params" do
        it "creates a new top-up" do
          expect {
            post "/api/v1/top_ups", params: valid_top_up, headers: token
          }.to change(TopUp, :count).by(1)
        end

        it "increases the user balance by the top-up amount" do
          expect {
            post "/api/v1/top_ups", params: valid_top_up, headers: token
          }.to change { user.reload.balance }.by(valid_top_up[:amount])
        end

        it "returns a success message" do
          post "/api/v1/top_ups", params: valid_top_up, headers: token
          expect(response).to have_http_status(:created)
          expect(response.body).to include("Top Up Successful 👍")
        end
      end

      context "with invalid params" do
        it "does not create a new top-up" do
          expect {
            post "/api/v1/top_ups", params: invalid_attributes, headers: token
          }.not_to change(TopUp, :count)
        end

        it "returns an error message" do
          post "/api/v1/top_ups", params: invalid_attributes, headers: token
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
        post "/api/v1/top_ups", params: valid_top_up
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("Invalid token!")
      end
    end
  end
end
