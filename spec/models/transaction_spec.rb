require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { build(:transaction) }

  describe "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0).with_message("must be present or greater than 0❗") }

    context "when phone_number_or_email is present" do
      subject { build(:transaction, phone_number_or_email: nil) }
      it { should_not be_valid }
      it { should validate_presence_of(:phone_number_or_email) }
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "callbacks" do
    describe "before_create" do
      describe "#capture_sending_time" do
        it "sets the sending_time attribute before creating a new transaction" do
          transaction = FactoryBot.build(:transaction, phone_number_or_email: "example@example.com", sending_time: nil)
          transaction.save
          expect(transaction.sending_time).not_to be_nil
        end
      end

      describe "#verify_recipient_user" do
        let(:user) { FactoryBot.create(:user) }

        it "throws an error if recipient user does not exist" do
          transaction = FactoryBot.build(:transaction, user: user, phone_number_or_email: "example@example.com")
          expect { transaction.save! }.to raise_error(ActiveRecord::RecordNotSaved)
        end

        it "does not throw an error if recipient user exists" do
          recipient = FactoryBot.create(:user, email: "example@example.com")
          transaction = FactoryBot.build(:transaction, user: user, phone_number_or_email: recipient.email)
          expect { transaction.save! }.not_to raise_error
        end
      end

      describe "#verify_amount" do
        let(:user) { FactoryBot.create(:user, balance: 100) }

        it "throws an error if amount is greater than user's balance" do
          transaction = FactoryBot.build(:transaction, user: user, amount: 200, phone_number_or_email: user.email)
          expect { transaction.save! }.to raise_error(ActiveRecord::RecordNotSaved)
        end

        it "does not throw an error if amount is less than or equal to user's balance" do
          recipient = FactoryBot.create(:user, email: "example@example.com")
          transaction = FactoryBot.build(:transaction, user: user, amount: 50, phone_number_or_email: recipient.email)
          expect { transaction.save! }.not_to raise_error
        end
      end

      describe "#block_self_transfer" do
        let(:user) { FactoryBot.create(:user, email: "example@example.com") }

        it "throws an error if the user tries to send to themselves" do
          transaction = FactoryBot.build(:transaction, user: user, phone_number_or_email: "example@example.com")
          expect { transaction.save! }.to raise_error(ActiveRecord::RecordNotSaved)
        end

        it "does not throw an error if the user sends to someone else" do
          recipient = FactoryBot.create(:user, email: "example2@example.com")
          transaction = FactoryBot.build(:transaction, user: user, phone_number_or_email: recipient.email)
          expect { transaction.save! }.not_to raise_error
        end
      end
    end
  end
end
