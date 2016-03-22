class AddIndexToHits < ActiveRecord::Migration
  def change
    add_index :hits, [:subject_id, :subject_type]
  end
end
