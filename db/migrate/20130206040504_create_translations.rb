class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :user_id
      t.string  :name
      t.string  :description
      t.text    :xslt
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
