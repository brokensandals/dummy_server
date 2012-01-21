class AddDelayToRules < ActiveRecord::Migration
  def change
    add_column :rules, :delay, :integer, :default => 0
  end
end
