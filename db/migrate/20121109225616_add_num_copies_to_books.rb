class AddNumCopiesToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :num_copies, :integer
  end

  def self.down
    remove_column :books, :num_copies
  end
end
