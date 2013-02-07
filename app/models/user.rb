# represents a user of the system
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :translations
end
