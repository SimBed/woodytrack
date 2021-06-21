class ChangeRelationshipPModelName < ActiveRecord::Migration[6.0]
  def change
    rename_table :relationship_ps, :rel_user_problems
  end
end
