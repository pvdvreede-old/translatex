class AddTranslationSecuritySettings < ActiveRecord::Migration
  def change
    add_column :translations, :api_key_enabled, :boolean
    add_column :translations, :api_key, :string
    add_column :translations, :basic_auth_enabled, :boolean
    add_column :translations, :basic_auth_username, :string
    add_column :translations, :basic_auth_password, :string
  end
end
