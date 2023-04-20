require 'rails_helper'

RSpec.describe TopUp, type: :model do
  describe "validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:phone_number) }
  end
end
