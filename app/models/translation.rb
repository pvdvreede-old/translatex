class Translation < ActiveRecord::Base
  attr_accessible :name, :identifier, :description, :xslt, :active

  belongs_to :user

  validates :name, :presence => true
  validates :user, :presence => true
  validates :xslt, :xml => true
  validates :identifier, :presence => true,
            :format => { :with => /^[a-zA-Z0-9]+$/ }
end
