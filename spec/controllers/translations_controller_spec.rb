# security tests for creating updating translations
require 'spec_helper'

describe TranslationsController do
  describe "#create" do
    before :each do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      sign_in @user1
    end

    it "should not allow the user to assign different user to creation" do
      lambda {
        post :create,
          :translation => FactoryGirl.attributes_for(
            :translation,
            :user_id => @user2.id
          )
      }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "#update" do
    before :each do
      @user1 = FactoryGirl.create :user
      @user2 = FactoryGirl.create :user
      @translation = FactoryGirl.create :translation, :user => @user2
      @user_translation = FactoryGirl.create :translation, :user => @user1
      sign_in @user1
    end

    it "should not allow updating of translations not owned by user" do
      lambda {
        put :update,
          :id => @translation,
          :translation => {
            :name => "changing name"
          }
      }.should raise_error(ActionController::RoutingError)
      db_translation = Translation.find(@translation.id)
      db_translation.name.should_not eq "changing name"
    end

    it "should not allow me to change ownership of other's translation" do
      lambda {
        put :update,
          :id => @translation,
          :translation => {
            :user_id => @user1.id
          }
      }.should raise_error(ActionController::RoutingError)
    end

    it "should not allow me to change ownership of user's translations" do
      lambda {
        put :update,
          :id => @user_translation,
          :translation => {
            :user_id => @user2.id
          }
      }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end