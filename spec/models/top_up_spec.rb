require 'rails_helper'

RSpec.describe TopUp, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_params) { { amount: 100, phone_number: user.phone_number, user_id: user.id } }
  let(:non_existent_user) { { amount: 100, phone_number: "1234567890", user_id: user.id } }
  subject(:top_up) { build(:top_up) }

  describe "before_create" do
    describe 'associations' do
      it { should belong_to(:user) }
    end

    context "when user exists" do
      it "creates a new top_up" do
        new_top_up = TopUp.new(valid_params)
        expect { new_top_up.save }.to change { TopUp.count }.by(1)
      end
    end

    context "when user does not exist" do
      it "does not create a new top_up" do
        new_top_up = TopUp.new(non_existent_user)
        expect { new_top_up.save }.not_to change { TopUp.count }
      end

      it "adds an error to the top_up object" do
        new_top_up = TopUp.new(non_existent_user)
        new_top_up.save
        expect(new_top_up.errors[:phone_number]).to include("does not exist 🚫")
      end
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:amount) }

    it do
      is_expected.to validate_numericality_of(:amount)
        .is_greater_than(0)
        .with_message("must be present or greater than 0❗")
    end
  end

  describe "callbacks" do
    context "before_create" do
      it "verifies the existence of user" do
        should callback(:verify_user).before(:create)
      end

      it "verifies the existence of current user" do
        should callback(:verify_current_user).before(:create)
      end
    end
  end
end
