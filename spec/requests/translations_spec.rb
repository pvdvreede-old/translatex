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

  describe "GET /translations/new" do
    before :all do
      @user = FactoryGirl.create :user
    end

    it "should redirect when not logged in" do
      visit '/translations/new'
      current_path.should eq "/login"
    end

    it "should display form when logged in" do
      valid_sign_in @user
      visit '/translations/new'
      current_path.should eq "/translations/new"
      page.should have_selector(".translation-form")
    end

    it "should save a valid translation for the user" do
      valid_sign_in @user
      visit '/translations/new'
      within ".translation-form" do
        fill_in "translation_name", :with => "My translation"
        fill_in "translation_identifier", :with => "mytran1"
        fill_in "translation_xslt", :with => "<root><h>test</h></root>"
      end
      click_button "Save"
      current_path.should eq "/translations"
      db_translation = Translation.where(
        :name => "My translation",
        :user_id => @user.id
        ).first
      db_translation.should_not be_nil
      db_translation.identifier.should eq "mytran1"
    end

    it "should not save a translation without a name" do
      valid_sign_in @user
      visit '/translations/new'
      within ".translation-form" do
        fill_in "translation_identifier", :with => "mytran2"
        fill_in "translation_xslt", :with => "<root><h>test</h></root>"
      end
      click_button "Save"
      current_path.should eq "/translations/new"
      page.should have_content("Name can't be blank")
      Translation.where(
        :identifier => "mytran2",
        :user_id => @user.id
        ).first.should be_nil
    end

    it "should not save a translation with invalid XML" do
      valid_sign_in @user
      visit '/translations/new'
      within ".translation-form" do
        fill_in "translation_name", :with => "My translation3"
        fill_in "translation_identifier", :with => "mytran3"
        fill_in "translation_xslt", :with => "<root><est</h></root>"
      end
      click_button "Save"
      current_path.should eq "/translations/new"
      page.should have_content("Xslt is not valid XML")
      Translation.where(
        :identifier => "mytran3",
        :user_id => @user.id
        ).first.should be_nil
    end
  end
end
