class AddUserIdentColumn < ActiveRecord::Migration
  def change
    add_column :users, :identifier, :string
    add_index :users, :identifier, :unique => true
  end
end
