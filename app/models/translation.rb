# represents an incoming endpoint and translation
# belongs to a user
class Translation < ActiveRecord::Base
  attr_accessible :name, :identifier, :description, :xslt, :active,
                  :api_key_enabled, :api_key, :basic_auth_enabled,
                  :basic_auth_username, :basic_auth_password

  belongs_to :user

  after_initialize :set_xslt_template

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

  def set_xslt_template
    self.xslt ||= <<-XSLTBASE
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <!-- put your xslt here -->
  </xsl:template>
</xsl:stylesheet>
XSLTBASE
  end

  def authentication_active?
    self.api_key_enabled || self.basic_auth_enabled
  end

  def all_authentication_active?
    self.api_key_enabled && self.basic_auth_enabled
  end
end
