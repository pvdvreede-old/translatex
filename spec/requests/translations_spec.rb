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
      page.should have_css(".tx-translations li", :count => 1)
    end

    it "should say I have no translations when I haven't created any" do
      valid_sign_in @empty_user
      visit '/translations'
      page.should_not have_selector(".tx-translations")
      page.should have_selector(".tx-empty-list")
      page.should have_content("You do not currently have any transations.")
    end

    it "should paginate the translations after 10 of them" do
      valid_sign_in @many_user
      visit '/translations'
      page.should have_css(".tx-translations li", :count => 10)
      page.should have_selector(".pagination")
      visit '/translations?page=2'
      page.should have_css(".tx-translations li", :count => 1)
      page.should have_selector(".pagination")
    end

    it "should have a link to create a new translation" do
      valid_sign_in @empty_user
      visit '/translations'
      page.should have_content('Create new translation')
    end

    it "should show corrent icons for security" do
      user = FactoryGirl.create :user
      insecure_translation = FactoryGirl.create(
        :translation,
        :user => user
      )
      api_secure_translation = FactoryGirl.create(
        :translation_with_api_key,
        :user => user
      )
      auth_secure_translation = FactoryGirl.create(
        :translation_with_basic_auth,
        :user => user
      )
      both_secure_translation = FactoryGirl.create(
        :translation_with_all_security,
        :user => user
      )
      valid_sign_in user
      visit '/translations'
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{insecure_translation.name}')]/div/span[contains(@class, 'tx-icon-unlock-stroke')]"
      )
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{api_secure_translation.name}')]/div/span[contains(@class, 'tx-icon-lock-stroke')]"
      )
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{auth_secure_translation.name}')]/div/span[contains(@class, 'tx-icon-lock-stroke')]"
      )
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{both_secure_translation.name}')]/div/span[contains(@class, 'tx-icon-lock-stroke')]"
      )
    end

    it "should show correct icons for active" do
      user = FactoryGirl.create :user
      translation = FactoryGirl.create(
        :translation,
        :user => user
      )
      inactive_translation = FactoryGirl.create(
        :translation,
        :active => false,
        :user => user
      )
      valid_sign_in user
      visit '/translations'
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{translation.name}')]/div/span[contains(@class, 'tx-icon-checkmark')]"
      )
      page.should have_xpath(
        "//li[@class='tx-translation' and contains(., '#{inactive_translation.name}')]/div/span[contains(@class, 'tx-icon-x')]"
      )
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
      page.should have_selector(".tx-translation-form")
    end

    it "should save a valid translation for the user" do
      valid_sign_in @user
      visit '/translations/new'
      within ".tx-translation-form" do
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

    it "should save valid translation with api key" do
      valid_sign_in @user
      visit "/translations/new"
      user_to_create = FactoryGirl.attributes_for(:translation_with_api_key)
      save_translation(user_to_create)

      db_translation = Translation.where(
        :user_id => @user.id,
        :identifier => user_to_create[:identifier]
      ).first

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.api_key_enabled.should eq true
      db_translation.api_key.should eq user_to_create[:api_key]
      current_path.should eq "/translations"
    end

    it "should save valid translation with basic auth" do
      valid_sign_in @user
      visit "/translations/new"
      user_to_create = FactoryGirl.attributes_for(:translation_with_basic_auth)
      save_translation(user_to_create)

      db_translation = Translation.where(
        :user_id => @user.id,
        :identifier => user_to_create[:identifier]
      ).first

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.basic_auth_enabled.should eq true
      db_translation.basic_auth_username.should eq user_to_create[:basic_auth_username]
      db_translation.basic_auth_password.should eq user_to_create[:basic_auth_password]
      db_translation.user_id.should eq @user.id
      current_path.should eq "/translations"
    end

    it "should save valid translation with basic auth and api key" do
      valid_sign_in @user
      visit "/translations/new"
      user_to_create = FactoryGirl.attributes_for(:translation_with_all_security)
      save_translation(user_to_create)

      db_translation = Translation.where(
        :user_id => @user.id,
        :identifier => user_to_create[:identifier]
      ).first

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.basic_auth_enabled.should eq true
      db_translation.basic_auth_username.should eq user_to_create[:basic_auth_username]
      db_translation.basic_auth_password.should eq user_to_create[:basic_auth_password]
      db_translation.api_key_enabled.should eq true
      db_translation.api_key.should eq user_to_create[:api_key]
      db_translation.user_id.should eq @user.id
      current_path.should eq "/translations"
    end

    it "should not save a translation without a name" do
      valid_sign_in @user
      visit '/translations/new'
      within ".tx-translation-form" do
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
      within ".tx-translation-form" do
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

  describe "GET /translation/:id/edit" do
    before :all do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
    end

    before :each do
      @translation = FactoryGirl.create :translation, :user => @user1
    end

    it "should redirect when not logged in" do
      visit "/translations/#{@translation.id.to_s}/edit"
      current_path.should eq "/login"
    end

    it "should show 404 when translation is not users" do
      valid_sign_in @user2
      lambda {
        visit "/translations/#{@translation.id.to_s}/edit"
      }.should raise_error(ActionController::RoutingError)
    end

    it "should show edit screen for translation owner" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      page.should have_selector(".tx-translation-form")
    end

    it "should show the right translation for editing" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      find_field("translation_name").value.should eq @translation.name
      find_field("translation_description").
        value.to_s.should eq @translation.description.to_s
      find_field("translation_identifier").
        value.to_s.should eq @translation.identifier
      find_field("translation_xslt").
        value.to_s.should eq @translation.xslt.to_s
    end

    it "should save valid updates to translation" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(:translation)
      save_translation(user_to_create)

      db_translation = Translation.find(@translation.id)

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.user_id.should eq @user1.id
      current_path.should eq "/translations"
    end

    it "should save valid updates with api key" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(:translation_with_api_key)
      save_translation(user_to_create)

      db_translation = Translation.find(@translation.id)

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.api_key_enabled.should eq true
      db_translation.api_key.should eq user_to_create[:api_key]
      db_translation.user_id.should eq @user1.id
      current_path.should eq "/translations"
    end

    it "should save valid updates with basic auth" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(:translation_with_basic_auth)
      save_translation(user_to_create)

      db_translation = Translation.find(@translation.id)

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.basic_auth_enabled.should eq true
      db_translation.basic_auth_username.should eq user_to_create[:basic_auth_username]
      db_translation.basic_auth_password.should eq user_to_create[:basic_auth_password]
      db_translation.user_id.should eq @user1.id
      current_path.should eq "/translations"
    end

    it "should save valid updates with basic auth and api key" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(:translation_with_all_security)
      save_translation(user_to_create)

      db_translation = Translation.find(@translation.id)

      db_translation.should_not be_nil
      db_translation.identifier.should eq user_to_create[:identifier]
      db_translation.name.should eq user_to_create[:name]
      db_translation.basic_auth_enabled.should eq true
      db_translation.basic_auth_username.should eq user_to_create[:basic_auth_username]
      db_translation.basic_auth_password.should eq user_to_create[:basic_auth_password]
      db_translation.api_key_enabled.should eq true
      db_translation.api_key.should eq user_to_create[:api_key]
      db_translation.user_id.should eq @user1.id
      current_path.should eq "/translations"
    end

    it "should not update with api enabled without a key" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(
        :translation_with_api_key,
        :api_key => ""
      )
      save_translation(user_to_create)

      current_path.should eq "/translations/#{@translation.id.to_s}/edit"
      page.should have_content("Api key cant be blank if api_key_enabled is enabled")
    end

    it "should not update a translation without a name" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(
        :translation,
        :name => ""
      )
      save_translation(user_to_create)
      current_path.should eq "/translations/#{@translation.id.to_s}/edit"
      page.should have_content("Name can't be blank")
    end

    it "should not update a translation without an identifier" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(
        :translation,
        :identifier => ""
      )
      save_translation(user_to_create)
      current_path.should eq "/translations/#{@translation.id.to_s}/edit"
      page.should have_content("Identifier can't be blank")
    end

    it "should not update a translation without valid xml" do
      valid_sign_in @user1
      visit "/translations/#{@translation.id.to_s}/edit"
      user_to_create = FactoryGirl.attributes_for(
        :translation,
        :xslt => "<changed><rtrue</r></changed>"
      )
      save_translation(user_to_create)
      current_path.should eq "/translations/#{@translation.id.to_s}/edit"
      page.should have_content("Xslt is not valid XML")
    end
  end

  describe "GET /transations/new form", :js => true do
    before :all do
      @user1 = FactoryGirl.create :user
    end

    it "should auto generate an API key when asked" do
      valid_sign_in @user1
      visit '/translations/new'
      find_field("translation_api_key").value.should eq ""
      click_link "Auto generate API key"
      find_field("translation_api_key").value.should_not eq ""
    end
  end
end

def save_translation(options)
  within ".tx-translation-form" do
    fill_in "translation_name", :with => options[:name]
    fill_in "translation_identifier", :with => options[:identifier]
    fill_in "translation_description", :with => options[:describe]
    fill_in "translation_xslt", :with => options[:xslt]
    (options[:api_key_enabled]) ? check("translation_api_key_enabled") : uncheck("translation_api_key_enabled")
    fill_in "translation_api_key", :with => options[:api_key]
    (options[:basic_auth_enabled]) ? check("translation_basic_auth_enabled") : uncheck("translation_basic_auth_enabled")
    fill_in "translation_basic_auth_username", :with => options[:basic_auth_username]
    fill_in "translation_basic_auth_password", :with => options[:basic_auth_password]
  end
  click_button "Save"
end