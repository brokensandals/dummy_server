class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.string :method_pattern
      t.string :path_pattern
      t.integer :precedence
      t.text :response_text

      t.timestamps
    end
  end
end
