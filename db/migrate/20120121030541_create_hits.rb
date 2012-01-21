class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.integer :rule_id
      t.string :env
      t.text :body

      t.timestamps
    end
  end
end
