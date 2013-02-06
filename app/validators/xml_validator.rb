class XmlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    begin
      Nokogiri::XML(value.to_s) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError
      record.errors[attribute] << (options[:message] || "is not valid XML")
    end
  end

end