class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :state
      t.datetime :completed_at
      t.datetime :canceled_at
      t.datetime :deadline
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
