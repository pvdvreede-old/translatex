# represents a user of the system
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :identifier

  has_many :translations

  validates :identifier, :presence => true,
            :format => { :with => /^[a-zA-Z0-9]+$/ },
            :uniqueness => true

end
