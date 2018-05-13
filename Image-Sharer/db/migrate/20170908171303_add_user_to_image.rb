class AddUserToImage < ActiveRecord::Migration[5.0]
  def up
    add_reference :images, :user, foreign_key: true

    execute <<-SQL
    update images set user_id = 1 where id%2 = 0;
    SQL
    execute <<-SQL
    update images set user_id = 2 where user_id is null;
    SQL

    change_column_null :images, :user_id, false
  end

  def down
    remove_column :images, :user_id
    remove_ya
  end
end
