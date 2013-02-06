require 'spec_helper'

describe Translation do
  describe "Validations" do
    it "MUST have a name" do
      FactoryGirl.build(:translation).should be_valid
      FactoryGirl.build(:translation, :name => "").should_not be_valid
      FactoryGirl.build(:translation, :name => nil).should_not be_valid
    end

    it "MUST have a user" do
      FactoryGirl.build(:translation).should be_valid
      FactoryGirl.build(:translation, :user => nil).should_not be_valid
    end

    it "CAN have a description" do
      FactoryGirl.build(:translation).should be_valid
      FactoryGirl.build(:translation, :description => "").should be_valid
      FactoryGirl.build(:translation, :description => nil).should be_valid
    end

    it "MUST have valid XML in xslt or be blank" do
      FactoryGirl.build(:translation).should be_valid
      FactoryGirl.build(:translation, :xslt => "sdfsdf>fsdf").should_not be_valid
      FactoryGirl.build(:translation, :xslt => "<valid>true</valid>").should be_valid
      FactoryGirl.build(:translation, :xslt => "<valid>true").should_not be_valid
    end
  end
end
