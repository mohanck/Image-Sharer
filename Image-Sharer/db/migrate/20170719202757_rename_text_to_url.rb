class RenameTextToUrl < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |t|
      t.rename :text, :url
    end
    change_column :images, :url, :string
  end
end
