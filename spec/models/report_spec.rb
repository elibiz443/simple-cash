require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:transactions).through(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    context "When start_date and end_date are within the allowed range" do
      it "creates report" do
        report = FactoryBot.build(:report)
        expect(report).to be_valid
      end
    end

    context "When start_date is out of the allowed range" do
      it "doesn't create a report" do
        report = FactoryBot.build(:report, start_date: (Time.zone.now - 121.days))
        expect(report).to be_invalid
      end
    end

    context "When end_date is out of the allowed range" do
      it "doesn't create a report" do
        report = FactoryBot.build(:report, start_date: (Time.zone.now + 2.days))
        expect(report).to be_invalid
      end
    end
  end
end
