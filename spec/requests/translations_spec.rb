require 'spec_helper'

describe "Translations" do
  describe "GET /translations" do
    before :all do
      @password = "test1212"
      @empty_user = FactoryGirl.create :user, :password => @password
      @one_user = FactoryGirl.create :user, :password => @password
      FactoryGirl.create :translation, :user => @one_user
      @many_user = FactoryGirl.create :user, :password => @password
      11.times do
        FactoryGirl.create :translation, :user => @many_user
      end
    end

    it "should redirect when not logged in" do
      visit '/translations'
      current_path.should eq "/login"
    end

    it "should be a valid list page if logged in" do
      valid_sign_in @empty_user
      visit '/translations'
      current_path.should eq "/translations"
    end

    it "should show me a list of my current translations when I have them" do
      valid_sign_in @one_user
      visit '/translations'
      page.should have_css(".translations li", :count => 1)
    end

    it "should say I have no translations when I haven't created any" do
      valid_sign_in @empty_user
      visit '/translations'
      page.should_not have_selector(".translations")
      page.should have_selector(".empty-list")
      page.should have_content("You do not currently have any transations.")
    end

    it "should paginate the translations after 10 of them" do
      valid_sign_in @many_user
      visit '/translations'
      page.should have_css(".translations li", :count => 10)
      page.should have_selector(".pagination")
      visit '/translations?page=2'
      page.should have_css(".translations li", :count => 1)
      page.should have_selector(".pagination")
    end

    it "should have a link to create a new translation" do
      valid_sign_in @empty_user
      visit '/translations'
      page.should have_content('Create new translation')
    end
  end
end
