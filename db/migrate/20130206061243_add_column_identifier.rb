class AddColumnIdentifier < ActiveRecord::Migration
  def change
    add_column :translations, :identifier, :string
  end
end
