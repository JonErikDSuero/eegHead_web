class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :professor, :default => false

      t.timestamps null: false
    end
  end
end
