class AddTotalNumCopiesToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :total_num_copies, :integer
  end

  def self.down
    remove_column :books, :total_num_copies
  end
end
