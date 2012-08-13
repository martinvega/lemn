class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :date, :null => false
      t.float :amount, :null => false
      t.string :concept, :null => false
      t.references :partner, :null => false
      t.references :user, :null => false
      t.integer :lock_version, :null => false, :default => 0

      t.timestamps
    end

    add_index :payments, :user_id
    add_index :payments, :partner_id
  end
end
