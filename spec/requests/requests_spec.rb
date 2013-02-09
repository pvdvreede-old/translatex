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

    it "should return 404 if the user identifier doesn't exist" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      lambda {
        post_request("noone", "doesntexist", post_xml)
      }.should raise_error(ActionController::RoutingError)
    end

    it "should return 404 if the translation doesn't exist" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      lambda {
        post_request(@user1.identifier, "doesntexist", post_xml)
      }.should raise_error(ActionController::RoutingError)
    end

    it "should return 404 if the translation isn't active" do
      post_xml, expected_xml = load_request_response("valid_xml_normal")
      lambda {
        post_request(
          @user1.identifier,
          @inactive_translation.identifier,
          post_xml
        )
      }.should raise_error(ActionController::RoutingError)
    end

  end
end

def post_request(user, translation, body)
  post(
    "/request/#{user}/#{translation}",
    body,
    { 'CONTENT_TYPE' => 'application/xml', 'ACCEPT' => 'application/xml' }
  )
end