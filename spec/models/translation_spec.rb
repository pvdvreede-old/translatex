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
      FactoryGirl.build(
        :translation,
        :xslt => "sdfsdf>fsdf"
        ).should_not be_valid
      FactoryGirl.build(
        :translation,
        :xslt => "<valid>true</valid>"
        ).should be_valid
      FactoryGirl.build(
        :translation,
        :xslt => "<valid>true"
        ).should_not be_valid
    end

    it "MUST have an identifier" do
      FactoryGirl.build(:translation).should be_valid
      FactoryGirl.build(:translation, :identifier => "").should_not be_valid
      FactoryGirl.build(:translation, :identifier => nil).should_not be_valid
    end

    it "MUST only have url friendly characters in the identifier" do
      FactoryGirl.build(:translation).should be_valid
      ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"].each do |char|
        FactoryGirl.build(
          :translation,
          :identifier => "sdfsd#{char}sdf"
          ).should_not be_valid
      end
    end

    it "MUST include an API key if api key is enabled" do
      FactoryGirl.build(:translation_with_api_key).should be_valid
      FactoryGirl.build(
        :translation_with_api_key,
        :api_key => ""
        ).should_not be_valid
    end

    it "api key can be blank if api not enabled" do
      FactoryGirl.build(:translation_with_api_key).should be_valid
      FactoryGirl.build(
        :translation_with_api_key,
        :api_key => "",
        :api_key_enabled => false
        ).should be_valid
    end

    it "MUST include basic auth username and password if basic auth enabled" do
      FactoryGirl.build(:translation_with_basic_auth).should be_valid
      FactoryGirl.build(
        :translation_with_basic_auth,
        :basic_auth_username => "",
        :basic_auth_password => ""
        ).should_not be_valid
    end

    it "MUST include basic auth username if basic auth enabled" do
      FactoryGirl.build(:translation_with_basic_auth).should be_valid
      FactoryGirl.build(
        :translation_with_basic_auth,
        :basic_auth_username => ""
        ).should_not be_valid
    end

    it "MUST include basic auth password if basic auth enabled" do
      FactoryGirl.build(:translation_with_basic_auth).should be_valid
      FactoryGirl.build(
        :translation_with_basic_auth,
        :basic_auth_password => ""
        ).should_not be_valid
    end
  end
end
