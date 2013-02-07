require 'spec_helper'

describe 'the registration process' do

  describe 'GET /register' do
    it 'should be a valid page' do
      get '/register'
      response.status.should be(200)
    end

    it 'should allow registration' do
      visit '/register'
      within '.register' do
        fill_in 'Email', :with => 'user@test.com'
        fill_in 'user_password', :with => 'password1212'
        fill_in 'user_password_confirmation', :with => 'password1212'
      end
      click_button 'Register'
      current_path.should_not eq('/register')
      user = User.where(:email => 'user@test.com').first
      user.should_not be_nil
      user.confirmed_at.should be_nil
    end

    it 'should not allow registration without email' do
      visit '/register'
      within '.register' do
        fill_in 'user_password', :with => 'password1212'
        fill_in 'user_password_confirmation', :with => 'password1212'
      end
      click_button 'Register'
      current_path.should eq('/register')
      page.should have_content("Email can't be blank")
    end

    it 'should not allow registration without password' do
      visit '/register'
      within '.register' do
        fill_in 'Email', :with => 'user@test2.com'
        fill_in 'user_password_confirmation', :with => 'password1212'
      end
      click_button 'Register'
      current_path.should eq('/register')
      page.should have_content("Password can't be blank")
    end

    it 'should not allow registration without password
        same as confirmation password' do
      visit '/register'
      within '.register' do
        fill_in 'Email', :with => 'user@test2.com'
        fill_in 'user_password', :with => 'password1212'
        fill_in 'user_password_confirmation', :with => 'notthesame'
      end
      click_button 'Register'
      current_path.should eq('/register')
      page.should have_content("Password doesn't match confirmation")
    end
  end

  describe ''

end