class CreateRelationshipPs < ActiveRecord::Migration[5.2]
  def change
    create_table :relationship_ps do |t|
      t.integer :user_id
      t.integer :problem_id
      t.string :suggestedgrade
      t.string :highpoint
      t.date :dohp
      t.date :firsttry
      t.integer :rating
      t.text :comment

      t.timestamps
    end
    add_index :relationship_ps, :user_id
    add_index :relationship_ps, :problem_id
    add_index :relationship_ps, [:user_id, :problem_id], unique: true
  end
end
