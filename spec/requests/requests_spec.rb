require 'spec_helper'

describe "Requests" do
  describe "POST /request/:user/:translation" do
    before :all do
      @user1 = FactoryGirl.create :user
      @translation = FactoryGirl.create :translation, :user => @user1
      @inactive_translation = FactoryGirl.create(
        :translation,
        :active => false,
        :user => @user1
      )
    end

    it "should accept a valid xml request for active translations
        and return result" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      @translation.xslt = xslt_xml
      @translation.save!
      post_request(@user1.identifier, @translation.identifier, post_xml)
      response.status.should eq 200
      response_xml_doc = Nokogiri::XML(response.body)
      expected_xml_doc = Nokogiri::XML(expected_xml)
      response_xml_doc.should be_equivalent_to(expected_xml_doc).
        respecting_element_order
    end

    it "should accept a valid request with api key security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_api_key,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :api_key_enabled => true,
          :api_key => translation.api_key }
      )
      response.status.should eq 200
      response_xml_doc = Nokogiri::XML(response.body)
      expected_xml_doc = Nokogiri::XML(expected_xml)
      response_xml_doc.should be_equivalent_to(expected_xml_doc).
        respecting_element_order
    end

    it "should accept a valid request with basic auth security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_basic_auth,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :basic_auth_enabled => true,
          :username => translation.basic_auth_username,
          :password => translation.basic_auth_password }
      )
      response.status.should eq 200
      response_xml_doc = Nokogiri::XML(response.body)
      expected_xml_doc = Nokogiri::XML(expected_xml)
      response_xml_doc.should be_equivalent_to(expected_xml_doc).
        respecting_element_order
    end

    it "should accept a valid basic auth request with all security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_all_security,
        :user => @user1,
        :xslt => xslt_xml
      )
      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :basic_auth_enabled => true,
          :username => translation.basic_auth_username,
          :password => translation.basic_auth_password }
      )
      response.status.should eq 200
      response_xml_doc = Nokogiri::XML(response.body)
      expected_xml_doc = Nokogiri::XML(expected_xml)
      response_xml_doc.should be_equivalent_to(expected_xml_doc).
        respecting_element_order
    end

    it "should accept a valid api auth request with all security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_all_security,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :api_key_enabled => true,
          :api_key => translation.api_key }
      )
      response.status.should eq 200
      response_xml_doc = Nokogiri::XML(response.body)
      expected_xml_doc = Nokogiri::XML(expected_xml)
      response_xml_doc.should be_equivalent_to(expected_xml_doc).
        respecting_element_order
    end

    it "should return 401 for incorrect basic auth request with all security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_all_security,
        :user => @user1,
        :xslt => xslt_xml
      )
      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :basic_auth_enabled => true,
          :username => "wrong",
          :password => "wrong" }
      )
      response.status.should eq 401
      response.body.should eq "HTTP Basic: Access denied.\n"
    end

    it "should return 401 for incorrect api auth request with all security" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_all_security,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :api_key_enabled => true,
          :api_key => "wrongapi" }
      )
      response.status.should eq 401
      response.body.should eq "HTTP Token: Access denied.\n"
    end

    it "should return 401 if the basic auth is not present" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_basic_auth,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml
      )
      response.status.should eq 401
      response.body.should eq "HTTP Basic: Access denied.\n"
    end

    it "should return 401 if the basic auth is wrong" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_basic_auth,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :basic_auth_enabled => true,
          :username => "doesntexist",
          :password => "notright" }
      )

      response.status.should eq 401
      response.body.should eq "HTTP Basic: Access denied.\n"
    end

    it "should return 401 if the api key is not present" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_api_key,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml
      )
      response.status.should eq 401
      response.body.should eq "HTTP Token: Access denied.\n"
    end

    it "should return 401 if the api key is wrong" do
      post_xml, expected_xml, xslt_xml = load_request_response(
        "valid_xml_normal"
      )
      translation = FactoryGirl.create(
        :translation_with_api_key,
        :user => @user1,
        :xslt => xslt_xml
      )

      post_request(
        @user1.identifier,
        translation.identifier,
        post_xml,
        { :api_key_enabled => true,
          :api_key => "thisisnotcorrect" }
      )

      response.status.should eq 401
      response.body.should eq "HTTP Token: Access denied.\n"
    end

    it "should return 400 if the xml is malformed" do

    end

    it "should return 415 if the request is not XML" do

    end

    it "should return 404 if the user identifier doesn't exist" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      post_request("noone", "doesntexist", post_xml)
      response.status.should eq 404
      response.body.should eq "<error>The resource does not exist</error>"
    end

    it "should return 404 if the translation doesn't exist" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      post_request(@user1.identifier, "doesntexist", post_xml)
      response.status.should eq 404
      response.body.should eq "<error>The resource does not exist</error>"
    end

    it "should return 404 if the translation isn't active" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      post_request(
        @user1.identifier,
        @inactive_translation.identifier,
        post_xml
      )
      response.status.should eq 404
      response.body.should eq "<error>The resource does not exist</error>"
    end
  end

  describe "GET /request/:user/:translation" do
    before :all do
      @user1 = FactoryGirl.create :user
      @translation = FactoryGirl.create :translation, :user => @user1
    end

    it "should return 405 if a GET method is used" do
      get "/request/#{@user1.identifier}/#{@translation.identifier}"
      response.status.should eq 405
    end
  end
end

def post_request(user, translation, body, options={})
  headers = Hash.new
  headers['CONTENT_TYPE'] = 'application/xml'
  headers['ACCEPT'] = 'application/xml'
  if options.has_key?(:basic_auth_enabled)
    headers['HTTP_AUTHORIZATION'] = create_basic_auth_token(
      options[:username],
      options[:password]
    )
  elsif options.has_key?(:api_key_enabled)
    headers['HTTP_AUTHORIZATION'] = create_api_key_token(
      options[:api_key]
    )
  end

  post(
    "/request/#{user}/#{translation}",
    body,
    headers
  )
end

def create_basic_auth_token(username, password)
  ActionController::HttpAuthentication::Basic.encode_credentials(
    username,
    password
  )
end

def create_api_key_token(api_key)
  ActionController::HttpAuthentication::Token.encode_credentials(api_key)
end