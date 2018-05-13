class ChangeColumnConstraint < ActiveRecord::Migration[5.0]
  def change
    change_column_null :tags, :name, false
    change_column_null :tags, :taggings_count, false
    change_column_null :taggings, :tag_id, false
    change_column_null :taggings, :taggable_id, false
    change_column_null :taggings, :taggable_type, false
    change_column_null :taggings, :created_at, false
    change_column_null :taggings, :context, false
  end
end
