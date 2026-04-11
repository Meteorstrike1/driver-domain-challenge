class CreateDriverRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :driver_records do |t|
      t.string :first_names, null: false
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.string :driving_licence_number, null: false
      t.string :driving_licence_type, null: false

      t.timestamps
    end
    add_index :driver_records, :driving_licence_number, unique: true
  end
end
