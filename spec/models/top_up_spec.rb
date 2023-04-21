require 'rails_helper'

RSpec.describe TopUp, type: :model do
  let(:user) { FactoryBot.create(:user, phone_number: "245-780-8171 x783") }
  let(:top_up_attributes) { FactoryBot.attributes_for(:top_up, phone_number: user.phone_number) }
  let(:non_existent_user) { FactoryBot.attributes_for(:top_up) }
  subject(:top_up) { build(:top_up) }

  describe "before_create" do
    context "when user exists" do
      it "creates a new top_up" do
        new_top_up = TopUp.new(top_up_attributes)
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
    end
  end
end
