class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :books, :num_copies, :avail_copies
  end

  def self.down
  end
end
