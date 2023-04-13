require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let(:user) { build(:user) } # Assumes you have a Factory Bot factory for creating User instances

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a first name" do
      user.first_name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a last name" do
      user.last_name = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a phone number" do
      user.phone_number = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a unique email" do
      existing_user = create(:user) # Assumes you have a Factory Bot factory for creating User instances
      user.email = existing_user.email
      expect(user).not_to be_valid
    end

    it "is not valid without a balance" do
      user.balance = nil
      expect(user).not_to be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).not_to be_valid
    end
  end
end
