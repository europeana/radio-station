class CreateOrigins < ActiveRecord::Migration[5.0]
  def change
    create_table :origins do |t|
      t.string :europeana_record_id
      t.json :metadata

      t.timestamps
    end
    add_index :origins, :europeana_record_id, unique: true
  end
end
