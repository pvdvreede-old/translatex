require 'spec_helper'

describe 'the registration process' do

  describe 'GET /register' do
    it 'should be a valid page' do
      get '/register'
      response.status.should be(200)
    end

    it 'should allow registration' do
      ActionMailer::Base.deliveries.count.should eq 0
      visit '/register'
      save_registration('user@test.com', "pvdvreede", 'password1212')
      current_path.should_not eq('/register')
      user = User.where(:email => 'user@test.com').first
      user.should_not be_nil
      user.confirmed_at.should be_nil
      ActionMailer::Base.deliveries.count.should eq 1
    end

    it 'should not allow registration without email' do
      visit '/register'
      save_registration(nil, "pvdvreede", 'password1212')
      current_path.should eq('/register')
      page.should have_content("Email can't be blank")
    end

    it "should not allow registration without unique email" do
      user = FactoryGirl.create :user
      visit '/register'
      save_registration(user.email, "pvdvreede1", 'password1212')
      current_path.should eq('/register')
      page.should have_content("Email has already been taken")
    end

    it 'should not allow registration without password' do
      visit '/register'
      save_registration('user@test1.com', "pvdvreede2", nil, 'password1212')
      current_path.should eq('/register')
      page.should have_content("Password can't be blank")
    end

    it 'should not allow registration without password
    same as confirmation password' do
      visit '/register'
      save_registration(
        'user@test2.com',
        "pvdvreede3",
        'password1212',
        'notthesame'
      )
      current_path.should eq('/register')
      page.should have_content("Password doesn't match confirmation")
    end

    it "should not allow registration without identifier" do
      visit '/register'
      save_registration(
        'user@test3.com',
        nil,
        'password1212',
        'notthesame'
      )
      current_path.should eq('/register')
      page.should have_content("Identifier can't be blank")
    end

    it "should not allow registration without unique identifier" do
      user = FactoryGirl.create :user
      visit '/register'
      save_registration(
        'user@test4.com',
        user.identifier,
        'password1212'
      )
      current_path.should eq('/register')
      page.should have_content("Identifier has already been taken")
    end

  end

end

def save_registration(email, identifier, password, confirm_password=password)
  within '.register' do
    fill_in 'Email', :with => email
    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => confirm_password
    fill_in 'user_identifier', :with => identifier
  end
  click_button 'Register'
end