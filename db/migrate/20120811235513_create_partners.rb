class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name, :null => false
      t.string :lastname, :null => false
      t.string :address
      t.integer :phone
      t.integer :movil_phone
      t.string :email
      t.date :admission_date
      t.date :birth_date
      t.integer :document
      t.references :user
      t.integer :lock_version, :null => false, :default => 0

      t.timestamps
    end

    add_index :partners, :user_id
  end
end
