class CreateApprovements < ActiveRecord::Migration[7.0]
  def change
    create_table :approvements do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :approvements, [:task_id, :user_id], unique: true
  end
end
