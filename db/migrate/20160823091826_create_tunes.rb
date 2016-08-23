class CreateTunes < ActiveRecord::Migration[5.0]
  def change
    create_table :tunes do |t|
      t.belongs_to :origin, index: true
      t.string :web_resource_uri

      t.timestamps
    end
    add_index :tunes, :web_resource_uri, unique: true
  end
end
