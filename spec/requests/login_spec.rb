require 'spec_helper'

describe "the login process" do
  describe "GET /login" do
    before :all do
      @user = FactoryGirl.create :user, :password => 'test1212'
    end

    it "should return a valid login page" do
      get '/login'
      response.status.should be(200)
    end

    it "should login a valid user" do
      visit '/login'
      current_path.should eq "/login"
      within '.login' do
        fill_in 'Email',:with => @user.email
        fill_in 'Password', :with => 'test1212'
      end
      click_button 'Login'
      current_path.should_not eq "/login"
      page.should_not have_selector(".login")
      page.should_not have_content("Invalid email or password.")
      page.should_not have_content("Login")
    end

    it "should reject an invalid password" do
      visit '/login'
      page.should_not have_content("Invalid email or password.")
      within '.login' do
        fill_in 'Email',:with => @user.email
        fill_in 'Password', :with => 'notright12'
      end
      click_button 'Login'
      page.should have_content("Invalid email or password.")
    end

    it "should reject an invalid username" do
      visit '/login'
      page.should_not have_content("Invalid email or password.")
      within '.login' do
        fill_in 'Email',:with => 'dontexist@notreal.com'
        fill_in 'Password', :with => 'test1212'
      end
      click_button 'Login'
      page.should have_content("Invalid email or password.")
    end
  end
end
