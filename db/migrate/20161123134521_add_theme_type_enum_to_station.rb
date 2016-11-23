class AddThemeTypeEnumToStation < ActiveRecord::Migration[5.0]
  def change
    add_column :stations, :theme_type, :integer, default: 0
    add_index :stations, :theme_type
  end
end
