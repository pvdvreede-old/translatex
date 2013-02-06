class Translation < ActiveRecord::Base
  attr_accessible :name, :description, :xslt, :active

  belongs_to :user

  validates :name, :presence => true
  validates :user, :presence => true
  validates :xslt, :xml => true
end
