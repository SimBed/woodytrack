class CreateProblems < ActiveRecord::Migration[5.2]
  def change
    create_table :problems do |t|
      t.string :name
      t.string :givengrade
      t.string :setter

      t.timestamps
    end
  end
end
