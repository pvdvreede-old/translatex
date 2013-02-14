# represents an incoming endpoint and translation
# belongs to a user
class Translation < ActiveRecord::Base
  attr_accessible :name, :identifier, :description, :xslt, :active,
                  :api_key_enabled, :api_key, :basic_auth_enabled,
                  :basic_auth_username, :basic_auth_password

  belongs_to :user

  validates :name, :presence => true
  validates :user, :presence => true
  validates :xslt, :xml => true
  validates :identifier, :presence => true,
            :format => { :with => /^[a-zA-Z0-9]+$/ }

  validates_with SetupFieldsValidator,
    :bool_field => :api_key_enabled,
    :value_fields_array => [:api_key]

  validates_with SetupFieldsValidator,
    :bool_field => :basic_auth_enabled,
    :value_fields_array => [:basic_auth_username, :basic_auth_password]

  def authentication_active?
    self.api_key_enabled || self.basic_auth_enabled
  end

  def all_authentication_active?
    self.api_key_enabled && self.basic_auth_enabled
  end
end
