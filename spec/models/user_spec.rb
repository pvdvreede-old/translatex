require 'spec_helper'

describe User do
  describe "Validations" do
    it "MUST have an identifier" do
      FactoryGirl.build(:user).should be_valid
      FactoryGirl.build(:user, :identifier => "").should_not be_valid
      FactoryGirl.build(:user, :identifier => nil).should_not be_valid
    end

    it "MUST have a unique identifier for all users" do
      @user1 = FactoryGirl.create(:user)
      FactoryGirl.build(
        :user,
        :identifier => @user1.identifier
      ).should_not be_valid
      FactoryGirl.build(
        :user,
        :identifier => "different"
      ).should be_valid
    end

    it "MUST only have url friendly characters in the identifier" do
      FactoryGirl.build(:user).should be_valid
      ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"].each do |char|
        FactoryGirl.build(
          :user,
          :identifier => "sdfsd#{char}sdf"
          ).should_not be_valid
      end
    end
  end
end
