class RenameManagersToUsers < ActiveRecord::Migration

  def change
    rename_table :managers, :users
  end

end
