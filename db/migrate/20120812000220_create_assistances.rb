class CreateAssistances < ActiveRecord::Migration
  def change
    create_table :assistances do |t|
      t.date :date, :null => false
      t.references :partner, :null => false
      t.references :user, :null => false
      t.integer :lock_version, :null => false, :default => 0

      t.timestamps
    end

    add_index :assistances, :partner_id
    add_index :assistances, :user_id
  end
end
