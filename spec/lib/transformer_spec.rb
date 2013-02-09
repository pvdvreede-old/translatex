require 'spec_helper'

describe Translatex::Transformer do
  describe "#transform" do
    context "with valid normal xml" do

      before :each do
        @xml, @expected, @xslt = load_request_response("valid_xml_normal")
        @transformer = Translatex::Transformer.new(@xml, @xslt)
      end

      it "should produce valid and expected xml" do
        actual_doc = @transformer.transform
        expected_doc = Nokogiri::XML(@expected)

        actual_doc.should be_equivalent_to(expected_doc).
          respecting_element_order
      end

    end

  end
end

