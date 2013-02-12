# Validator for making sure that if a bool is ticked, the
# setup fields for that feature are not blank
class SetupFieldsValidator < ActiveModel::Validator

  def validate(record)
    bool_value = record[options[:bool_field]]
    if bool_value
      options[:value_fields_array].each do |field|
        value = record[field]
        if value.nil? || value.empty?
          record.errors[field] << (options[:message] ||
              "cant be blank if #{options[:bool_field].to_s} is enabled")
        end
      end
    end
  end

end